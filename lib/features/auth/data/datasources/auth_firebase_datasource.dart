import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Datasource de autenticación sobre Firebase (proyecto
/// mercado-cercano-28190): Firebase Auth con teléfono/SMS y perfil de
/// usuario en Cloud Firestore (colección `users`).
///
/// Se activa cuando `AppConstants.useMockData == false` y
/// `AppConstants.useFirebaseAuth == true` (ver `auth_provider.dart`).
///
/// Requisitos en la consola de Firebase para que funcione en runtime:
/// - Authentication → Sign-in method → habilitar "Phone".
/// - Firestore Database → crear la base de datos.
/// - Android: registrar el SHA-1/SHA-256 de la app (Play Integrity).
/// - iOS: subir la key de APNs (los SMS usan silent push).
class AuthFirebaseDatasource implements AuthRemoteDatasource {
  AuthFirebaseDatasource({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  /// Id de verificación que entrega Firebase en `codeSent`; se necesita
  /// para construir la credencial al verificar el OTP.
  String? _verificationId;
  int? _resendToken;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  @override
  Future<void> sendOtp(String phone) async {
    final completer = Completer<void>();

    await _auth.verifyPhoneNumber(
      phoneNumber: phone, // ya viene normalizado: +502XXXXXXXX
      forceResendingToken: _resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (_) {
        // Auto-verificación de Android: se ignora para mantener el flujo
        // uniforme (el usuario siempre escribe el código).
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) {
          completer.completeError(_mapFirebaseAuthException(e));
        }
      },
      codeSent: (verificationId, resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
        if (!completer.isCompleted) completer.complete();
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );

    return completer.future;
  }

  @override
  Future<AuthResponseModel> verifyOtp({
    required String phone,
    required String otp,
    UserRole? role,
  }) async {
    final verificationId = _verificationId;
    if (verificationId == null) {
      throw const AuthException(
        'Primero solicita un código de verificación.',
      );
    }

    final UserCredential credential;
    try {
      credential = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        ),
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }

    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw const AuthException('No se pudo iniciar sesión.');
    }

    // Perfil en Firestore: users/{uid}.
    final doc = await _users.doc(firebaseUser.uid).get();
    final data = doc.data();
    final existingRole = data?['role'] as String?;
    final effectiveRole = role?.name ?? existingRole;
    // Es nuevo si todavía no tiene rol asignado (debe pasar por el
    // selector de rol).
    final isNewUser = effectiveRole == null;

    if (!doc.exists) {
      await _users.doc(firebaseUser.uid).set({
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'role': ?effectiveRole,
        'subscription': 'free',
      });
    } else if (role != null && role.name != existingRole) {
      await _users.doc(firebaseUser.uid).update({'role': role.name});
    }

    return AuthResponseModel(
      accessToken: await firebaseUser.getIdToken() ?? '',
      refreshToken: firebaseUser.refreshToken ?? '',
      isNewUser: isNewUser,
      user: _buildUser(
        firebaseUser,
        phone: phone,
        role: effectiveRole,
        data: data,
      ),
    );
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw const AuthException('La sesión expiró. Inicia sesión de nuevo.');
    }
    // Firebase renueva el ID token internamente; `true` fuerza el refresh.
    final idToken = await firebaseUser.getIdToken(true) ?? '';
    final data = (await _users.doc(firebaseUser.uid).get()).data();

    return AuthResponseModel(
      accessToken: idToken,
      refreshToken: firebaseUser.refreshToken ?? '',
      user: _buildUser(
        firebaseUser,
        phone: data?['phone'] as String? ?? firebaseUser.phoneNumber ?? '',
        role: data?['role'] as String?,
        data: data,
      ),
    );
  }

  @override
  Future<UserModel> setRole(UserRole role) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw const AuthException('La sesión expiró. Inicia sesión de nuevo.');
    }
    await _users.doc(firebaseUser.uid).set(
      {'role': role.name},
      SetOptions(merge: true),
    );
    final data = (await _users.doc(firebaseUser.uid).get()).data();
    return _buildUser(
      firebaseUser,
      phone: data?['phone'] as String? ?? firebaseUser.phoneNumber ?? '',
      role: role.name,
      data: data,
    );
  }

  @override
  Future<void> logout() => _auth.signOut();

  // -------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------

  UserModel _buildUser(
    User firebaseUser, {
    required String phone,
    String? role,
    Map<String, dynamic>? data,
  }) {
    return UserModel(
      id: firebaseUser.uid,
      phone: phone,
      // Sin rol todavía: 'buyer' como valor de transporte; `isNewUser`
      // obliga a pasar por el selector antes de usar la app.
      role: role ?? 'buyer',
      createdAt:
          (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      name: data?['name'] as String?,
      rating: (data?['rating'] as num?)?.toDouble(),
      totalRatings: data?['totalRatings'] as int?,
      isVerified: data?['isVerified'] as bool?,
      subscription: data?['subscription'] as String?,
    );
  }

  /// Traduce los códigos de FirebaseAuthException a las excepciones del
  /// dominio con mensajes en español.
  AppException _mapFirebaseAuthException(FirebaseAuthException e) {
    return switch (e.code) {
      'invalid-verification-code' =>
        const ValidationException('El código ingresado es incorrecto.'),
      'session-expired' || 'code-expired' =>
        const AuthException('El código expiró. Solicita uno nuevo.'),
      'invalid-phone-number' =>
        const ValidationException('El número de teléfono no es válido.'),
      'too-many-requests' => const AuthException(
          'Demasiados intentos. Espera unos minutos e intenta de nuevo.',
        ),
      'network-request-failed' => const NetworkException(
          'Sin conexión. Revisa tu internet e intenta de nuevo.',
        ),
      _ => AuthException(e.message ?? 'Error de autenticación (${e.code}).'),
    };
  }
}

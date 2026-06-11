import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../shared/domain/entities/user_entity.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

/// Autenticación sobre Firebase (proyecto mercado-cercano-28190):
/// Google Sign-In (principal), Apple Sign-In (iOS) y Email/Password.
///
/// Requisitos en Firebase Console (Authentication → Sign-in method):
/// habilitar Google, Apple y Email/Password. Tras habilitar Google hay
/// que re-descargar google-services.json / GoogleService-Info.plist
/// (`flutterfire configure`) para que incluyan los OAuth clients, y en
/// iOS poner el REVERSED_CLIENT_ID en el CFBundleURLTypes de Info.plist.
class AuthFirebaseDatasource implements AuthRemoteDatasource {
  AuthFirebaseDatasource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  // -------------------------------------------------------------------
  // Google (método principal)
  // -------------------------------------------------------------------

  @override
  Future<AuthResponseModel> signInWithGoogle() async {
    final GoogleSignInAccount? account;
    try {
      account = await _googleSignIn.signIn();
    } catch (_) {
      throw const AuthException(
        'No se pudo conectar con Google. Intenta de nuevo.',
      );
    }
    if (account == null) {
      // El usuario cerró el selector de cuenta.
      throw const ValidationException('Operación cancelada');
    }

    final googleAuth = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    return _completeSignIn(
      credential,
      loginMethod: 'google',
      displayName: account.displayName,
      email: account.email,
      photoUrl: account.photoUrl,
    );
  }

  // -------------------------------------------------------------------
  // Apple (solo iOS)
  // -------------------------------------------------------------------

  @override
  Future<AuthResponseModel> signInWithApple() async {
    final AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.fullName,
          AppleIDAuthorizationScopes.email,
        ],
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const ValidationException('Operación cancelada');
      }
      throw const AuthException(
        'No se pudo conectar con Apple. Intenta de nuevo.',
      );
    }

    final credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Apple SOLO entrega el nombre la PRIMERA vez: hay que persistirlo
    // de inmediato porque en logins posteriores viene null.
    final fullName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().join(' ').trim();

    return _completeSignIn(
      credential,
      loginMethod: 'apple',
      displayName: fullName.isEmpty ? null : fullName,
      email: appleCredential.email,
    );
  }

  // -------------------------------------------------------------------
  // Email/Password (respaldo)
  // -------------------------------------------------------------------

  @override
  Future<AuthResponseModel> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential credential;
    try {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }

    // Verificación de correo: no bloquea el acceso, pero queda enviada.
    try {
      await credential.user?.sendEmailVerification();
    } catch (_) {
      // best-effort
    }

    return _finishWithUser(
      credential.user,
      loginMethod: 'email',
      displayName: name,
      email: email,
    );
  }

  @override
  Future<AuthResponseModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final UserCredential credential;
    try {
      credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
    return _finishWithUser(
      credential.user,
      loginMethod: 'email',
      email: email,
    );
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
  }

  // -------------------------------------------------------------------
  // Sesión / rol / logout
  // -------------------------------------------------------------------

  @override
  Future<UserModel> setRole(UserRole role) async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      throw const AuthException('La sesión expiró. Inicia sesión de nuevo.');
    }
    await _users.doc(firebaseUser.uid).set(
      {
        'role': role.name,
        'lastRoleChange': FieldValue.serverTimestamp(),
        if (role == UserRole.vendor) 'hasBeenVendor': true,
        if (role == UserRole.buyer) 'hasBeenBuyer': true,
      },
      SetOptions(merge: true),
    );
    final data = (await _users.doc(firebaseUser.uid).get()).data();
    return _buildUser(firebaseUser, role: role.name, data: data);
  }

  @override
  Future<void> logout() async {
    // Cerrar también la sesión del proveedor social para que el próximo
    // login muestre el selector de cuenta.
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // best-effort
    }
    await _auth.signOut();
  }

  @override
  Future<AuthResponseModel?> restoreSession() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    // Silent refresh del ID token; si falla por red, el repositorio cae
    // a los datos guardados (modo offline) en vez de cerrar la sesión.
    final String idToken;
    try {
      idToken = await firebaseUser.getIdToken(true) ?? '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') return null;
      throw _mapFirebaseAuthException(e);
    }

    final data = (await _users.doc(firebaseUser.uid).get()).data();
    final role = data?['role'] as String?;
    return AuthResponseModel(
      accessToken: idToken,
      refreshToken: firebaseUser.refreshToken ?? '',
      isNewUser: role == null,
      user: _buildUser(firebaseUser, role: role, data: data),
    );
  }

  @override
  Stream<bool> watchSessionActive() {
    // authStateChanges es la fuente de verdad de la sesión de Firebase.
    return _auth.authStateChanges().map((user) => user != null);
  }

  // -------------------------------------------------------------------
  // Internos
  // -------------------------------------------------------------------

  /// Sign-in con credencial federada + perfil/auditoría en `users/{uid}`.
  Future<AuthResponseModel> _completeSignIn(
    AuthCredential credential, {
    required String loginMethod,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    final UserCredential userCredential;
    try {
      userCredential = await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    }
    return _finishWithUser(
      userCredential.user,
      loginMethod: loginMethod,
      displayName: displayName,
      email: email,
      photoUrl: photoUrl,
    );
  }

  /// Actualiza/crea `users/{uid}` (perfil + métricas de login) y arma la
  /// respuesta. Compartido por los tres métodos de acceso.
  Future<AuthResponseModel> _finishWithUser(
    User? firebaseUser, {
    required String loginMethod,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    if (firebaseUser == null) {
      throw const AuthException('No se pudo iniciar sesión.');
    }

    final doc = await _users.doc(firebaseUser.uid).get();
    final data = doc.data();
    final existingRole = data?['role'] as String?;
    // Es nuevo si todavía no tiene rol (debe pasar por el selector).
    final isNewUser = existingRole == null;

    final name = displayName ??
        data?['name'] as String? ??
        firebaseUser.displayName;
    final effectiveEmail =
        email ?? data?['email'] as String? ?? firebaseUser.email;
    final effectivePhoto = photoUrl ??
        data?['photoUrl'] as String? ??
        firebaseUser.photoURL;

    final deviceInfo = {
      'platform': Platform.operatingSystem,
      'appVersion': AppConstants.appVersion,
    };

    if (!doc.exists) {
      // Primer login: documento completo. `role` queda pendiente hasta
      // pasar por el selector de rol; `phone` ya no es parte del alta.
      await _users.doc(firebaseUser.uid).set({
        'name': ?name,
        'email': ?effectiveEmail,
        'photoUrl': ?effectivePhoto,
        'phone': null,
        'subscription': 'free',
        'loginMethod': loginMethod,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'loginCount': 1,
        'deviceInfo': deviceInfo,
      });
    } else {
      // Login recurrente: métricas de sesión. El nombre de Apple solo
      // llega la primera vez, así que solo se escribe si trae valor.
      await _users.doc(firebaseUser.uid).set({
        'lastLoginAt': FieldValue.serverTimestamp(),
        'loginCount': FieldValue.increment(1),
        'loginMethod': loginMethod,
        'deviceInfo': deviceInfo,
        if (displayName != null && displayName.isNotEmpty)
          'name': displayName,
        if (data?['photoUrl'] == null && effectivePhoto != null)
          'photoUrl': effectivePhoto,
      }, SetOptions(merge: true));
    }

    return AuthResponseModel(
      accessToken: await firebaseUser.getIdToken() ?? '',
      refreshToken: firebaseUser.refreshToken ?? '',
      isNewUser: isNewUser,
      user: _buildUser(
        firebaseUser,
        role: existingRole,
        data: data,
        nameOverride: name,
        emailOverride: effectiveEmail,
        photoOverride: effectivePhoto,
        loginMethod: loginMethod,
      ),
    );
  }

  UserModel _buildUser(
    User firebaseUser, {
    String? role,
    Map<String, dynamic>? data,
    String? nameOverride,
    String? emailOverride,
    String? photoOverride,
    String? loginMethod,
  }) {
    return UserModel(
      id: firebaseUser.uid,
      phone: data?['phone'] as String? ?? firebaseUser.phoneNumber ?? '',
      // Sin rol todavía: 'buyer' como valor de transporte; `isNewUser`
      // obliga a pasar por el selector antes de usar la app.
      role: role ?? 'buyer',
      createdAt:
          (data?['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      name: nameOverride ?? data?['name'] as String?,
      email: emailOverride ?? data?['email'] as String?,
      photoUrl: photoOverride ?? data?['photoUrl'] as String?,
      loginMethod: loginMethod ?? data?['loginMethod'] as String?,
      rating: (data?['rating'] as num?)?.toDouble(),
      totalRatings: data?['totalRatings'] as int?,
      isVerified: data?['isVerified'] as bool?,
      subscription: data?['subscription'] as String?,
    );
  }

  /// FirebaseAuthException → excepciones del dominio (español).
  AppException _mapFirebaseAuthException(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' =>
        const ValidationException('No existe cuenta con ese email'),
      'wrong-password' || 'invalid-credential' =>
        const ValidationException('Contraseña incorrecta'),
      'email-already-in-use' =>
        const ValidationException('Ya existe una cuenta con ese email'),
      'weak-password' => const ValidationException(
          'La contraseña debe tener al menos 8 caracteres',
        ),
      'invalid-email' =>
        const ValidationException('El formato del email no es válido'),
      'account-exists-with-different-credential' => const AuthException(
          'Ya existe una cuenta con ese email usando otro método de '
          'acceso. Usa el método original.',
        ),
      'too-many-requests' => const AuthException(
          'Demasiados intentos. Espera unos minutos e intenta de nuevo.',
        ),
      'network-request-failed' => const NetworkException(
          'Sin conexión a internet',
        ),
      'operation-not-allowed' => const AuthException(
          'Este método de acceso no está habilitado. '
          'Contacta al administrador.',
        ),
      _ => AuthException(e.message ?? 'Error de autenticación (${e.code}).'),
    };
  }
}

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Permiso y registro de notificaciones push (FCM).
///
/// El permiso se solicita EN CONTEXTO (al entrar a Alertas de precio),
/// NUNCA al arrancar la app: App Store y Google Play penalizan pedir
/// permisos sin un motivo visible para el usuario.
class PushNotificationService {
  PushNotificationService({FirebaseMessaging? messaging})
      : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  /// Pide el permiso (si el usuario aún no decidió) y registra el token
  /// del dispositivo. Best-effort: cualquier fallo se ignora para no
  /// interrumpir el flujo (p. ej. sin Google Play / sin APNs).
  Future<void> ensurePermissionAndRegister() async {
    try {
      final settings = await _messaging.requestPermission();
      final status = settings.authorizationStatus;
      if (status == AuthorizationStatus.authorized ||
          status == AuthorizationStatus.provisional) {
        final token = await _messaging.getToken();
        if (kDebugMode) debugPrint('FCM token: $token');
        // En producción: enviar el token al backend para las alertas.
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Push permiso/registro falló: $e');
    }
  }
}

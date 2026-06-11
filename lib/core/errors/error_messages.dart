/// Mensajes de error en español para los códigos de Firebase
/// (Auth/Firestore/Storage).
///
/// Es la REFERENCIA ÚNICA de mensajes. Nota: `firestore_service.dart` y
/// `auth_firebase_datasource.dart` mapean sus códigos a `AppException`
/// con estos mismos textos; este helper sirve para cualquier código
/// suelto que llegue a la UI u otros datasources.
class ErrorMessages {
  ErrorMessages._();

  static const String fallback = 'Ocurrió un error, intenta de nuevo';

  static const Map<String, String> _byCode = {
    'network-request-failed': 'Sin conexión a internet',
    'invalid-phone-number': 'Número de teléfono inválido',
    'invalid-verification-code': 'Código incorrecto, intenta de nuevo',
    'session-expired': 'El código expiró, solicita uno nuevo',
    'code-expired': 'El código expiró, solicita uno nuevo',
    'too-many-requests': 'Demasiados intentos, espera unos minutos',
    'quota-exceeded': 'Servicio temporalmente no disponible',
    'permission-denied': 'No tienes permiso para realizar esta acción',
    'not-found': 'No se encontró la información solicitada',
    'cancelled': 'Operación cancelada',
    'unavailable': 'Sin conexión a internet',
    'deadline-exceeded': 'Sin conexión a internet',
  };

  /// Mensaje en español para [code]; [fallback] si no está mapeado.
  static String of(String? code) => _byCode[code] ?? fallback;
}

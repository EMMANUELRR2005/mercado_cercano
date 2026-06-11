import '../constants/app_constants.dart';

/// Validadores de formularios. Devuelven `null` si el valor es válido,
/// o un mensaje de error en español si no lo es.
class Validators {
  Validators._();

  /// Valida un número de teléfono de Guatemala: exactamente 8 dígitos.
  ///
  /// Acepta también el formato con prefijo (+502 XXXXXXXX) por si el
  /// usuario pega el número completo. No se restringe el primer dígito:
  /// la numeración GT incluye fijos (2, 6, 7) y celulares (3, 4, 5).
  static String? validatePhoneGt(String? value) {
    var phone = value?.replaceAll(RegExp(r'[\s\-+]'), '') ?? '';
    // Si pegaron el número con código de país (502XXXXXXXX), quitarlo.
    if (phone.length == 11 && phone.startsWith('502')) {
      phone = phone.substring(3);
    }
    if (phone.isEmpty) {
      return 'Ingresa tu número de teléfono';
    }
    if (!RegExp(r'^\d{8}$').hasMatch(phone)) {
      return 'El número debe tener 8 dígitos';
    }
    return null;
  }

  /// Valida un precio: mayor que 0 y con máximo 2 decimales.
  static String? validatePrice(String? value) {
    final raw = value?.trim().replaceAll(',', '.') ?? '';
    if (raw.isEmpty) {
      return 'Ingresa el precio';
    }
    final price = double.tryParse(raw);
    if (price == null) {
      return 'Ingresa un precio válido';
    }
    if (price <= 0) {
      return 'El precio debe ser mayor que cero';
    }
    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(value!.trim())) {
      return 'Máximo 2 decimales';
    }
    return null;
  }

  /// Valida el código OTP: exactamente 6 dígitos.
  static String? validateOtp(String? value) {
    final otp = value?.trim() ?? '';
    if (otp.isEmpty) {
      return 'Ingresa el código';
    }
    if (!RegExp('^\\d{${AppConstants.otpLength}}\$').hasMatch(otp)) {
      return 'El código debe tener ${AppConstants.otpLength} dígitos';
    }
    return null;
  }

  /// Valida que el campo no esté vacío.
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? 'Ingresa $fieldName'
          : 'Este campo es obligatorio';
    }
    return null;
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'MercadoCercano';

  @override
  String get tagline => 'Precios del mercado, en tu bolsillo';

  @override
  String get phoneInputTitle => '¿Cuál es tu número?';

  @override
  String get phoneInputSubtitle => 'Te enviaremos un código de verificación';

  @override
  String get sendCode => 'Enviar código';

  @override
  String get verifyCode => 'Verificar código';

  @override
  String get otpInputTitle => 'Ingresa el código';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get iAmBuyer => 'Soy Comprador';

  @override
  String get iAmVendor => 'Soy Vendedor';

  @override
  String get publishProduct => 'Publicar producto';

  @override
  String get renewAll => 'Renovar todo';

  @override
  String get markSoldOut => 'Marcar como agotado';

  @override
  String get soldOut => 'Agotado';

  @override
  String get priceIndex => 'Índice de precios';

  @override
  String get nearbyVendors => 'Vendedores cercanos';

  @override
  String get averagePriceInZone => 'Precio promedio en tu zona';

  @override
  String get reportPrice => 'Reportar precio';

  @override
  String get setAlert => 'Crear alerta de precio';

  @override
  String get verifiedVendor => 'Vendedor Verificado';

  @override
  String get noInternetBanner => 'Sin conexión — mostrando datos guardados';

  @override
  String expiresIn(String time) {
    return 'Vence en $time';
  }

  @override
  String get featuredPost => 'Publicación Destacada';

  @override
  String get featured => 'Destacado';

  @override
  String get upgradeToProTitle => 'Función Premium';

  @override
  String upgradeToProSubtitle(String featureName) {
    return 'Accede a $featureName con el Plan Pro';
  }

  @override
  String get upgradeToPro => 'Mejorar a Pro';

  @override
  String get rateVendorTitle => 'Calificar vendedor';

  @override
  String get rateVendorQuestion =>
      '¿Cómo fue tu experiencia con este vendedor?';

  @override
  String get commentOptionalLabel => 'Comentario (opcional)';

  @override
  String get submitRating => 'Enviar calificación';

  @override
  String get ratingThanks => '¡Gracias por tu calificación!';

  @override
  String get vendorReviewsTitle => 'Reseñas del vendedor';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reseñas',
      one: '1 reseña',
    );
    return '$_temp0';
  }

  @override
  String get noReviewsTitle => 'Aún no hay reseñas';

  @override
  String get noReviewsSubtitle =>
      'Sé la primera persona en calificar a este vendedor.';

  @override
  String get reportFraud => 'Reportar fraude';

  @override
  String get retry => 'Reintentar';

  @override
  String reportsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reportes',
      one: '1 reporte',
    );
    return '$_temp0';
  }
}

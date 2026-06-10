import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Nombre de la aplicación
  ///
  /// In es, this message translates to:
  /// **'MercadoCercano'**
  String get appName;

  /// Eslogan de la app, se muestra en splash y onboarding
  ///
  /// In es, this message translates to:
  /// **'Precios del mercado, en tu bolsillo'**
  String get tagline;

  /// Título de la pantalla de ingreso de teléfono
  ///
  /// In es, this message translates to:
  /// **'¿Cuál es tu número?'**
  String get phoneInputTitle;

  /// Subtítulo de la pantalla de ingreso de teléfono
  ///
  /// In es, this message translates to:
  /// **'Te enviaremos un código de verificación'**
  String get phoneInputSubtitle;

  /// Botón para enviar el código OTP
  ///
  /// In es, this message translates to:
  /// **'Enviar código'**
  String get sendCode;

  /// Botón para verificar el código OTP
  ///
  /// In es, this message translates to:
  /// **'Verificar código'**
  String get verifyCode;

  /// Título de la pantalla de OTP
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código'**
  String get otpInputTitle;

  /// Botón para reenviar el código OTP
  ///
  /// In es, this message translates to:
  /// **'Reenviar código'**
  String get resendCode;

  /// Opción de rol comprador
  ///
  /// In es, this message translates to:
  /// **'Soy Comprador'**
  String get iAmBuyer;

  /// Opción de rol vendedor
  ///
  /// In es, this message translates to:
  /// **'Soy Vendedor'**
  String get iAmVendor;

  /// Botón para publicar un producto nuevo
  ///
  /// In es, this message translates to:
  /// **'Publicar producto'**
  String get publishProduct;

  /// Botón para renovar la vigencia de todos los productos
  ///
  /// In es, this message translates to:
  /// **'Renovar todo'**
  String get renewAll;

  /// Acción para marcar un producto como agotado
  ///
  /// In es, this message translates to:
  /// **'Marcar como agotado'**
  String get markSoldOut;

  /// Badge de producto agotado
  ///
  /// In es, this message translates to:
  /// **'Agotado'**
  String get soldOut;

  /// Título de la pantalla del índice de precios
  ///
  /// In es, this message translates to:
  /// **'Índice de precios'**
  String get priceIndex;

  /// Sección de vendedores cercanos
  ///
  /// In es, this message translates to:
  /// **'Vendedores cercanos'**
  String get nearbyVendors;

  /// Etiqueta del precio promedio de la zona
  ///
  /// In es, this message translates to:
  /// **'Precio promedio en tu zona'**
  String get averagePriceInZone;

  /// Botón para reportar un precio visto en el mercado
  ///
  /// In es, this message translates to:
  /// **'Reportar precio'**
  String get reportPrice;

  /// Botón para crear una alerta de precio
  ///
  /// In es, this message translates to:
  /// **'Crear alerta de precio'**
  String get setAlert;

  /// Insignia de vendedor verificado
  ///
  /// In es, this message translates to:
  /// **'Vendedor Verificado'**
  String get verifiedVendor;

  /// Banner que aparece cuando no hay conexión a internet
  ///
  /// In es, this message translates to:
  /// **'Sin conexión — mostrando datos guardados'**
  String get noInternetBanner;

  /// Cuenta regresiva de vencimiento de una publicación
  ///
  /// In es, this message translates to:
  /// **'Vence en {time}'**
  String expiresIn(String time);

  /// Etiqueta de publicación destacada (premium)
  ///
  /// In es, this message translates to:
  /// **'Publicación Destacada'**
  String get featuredPost;

  /// Badge corto de producto destacado
  ///
  /// In es, this message translates to:
  /// **'Destacado'**
  String get featured;

  /// Título del overlay de función premium
  ///
  /// In es, this message translates to:
  /// **'Función Premium'**
  String get upgradeToProTitle;

  /// Subtítulo del overlay de función premium
  ///
  /// In es, this message translates to:
  /// **'Accede a {featureName} con el Plan Pro'**
  String upgradeToProSubtitle(String featureName);

  /// Botón para mejorar al plan Pro
  ///
  /// In es, this message translates to:
  /// **'Mejorar a Pro'**
  String get upgradeToPro;

  /// Título de la pantalla para calificar a un vendedor
  ///
  /// In es, this message translates to:
  /// **'Calificar vendedor'**
  String get rateVendorTitle;

  /// Pregunta principal de la pantalla de calificación
  ///
  /// In es, this message translates to:
  /// **'¿Cómo fue tu experiencia con este vendedor?'**
  String get rateVendorQuestion;

  /// Etiqueta del campo de comentario opcional
  ///
  /// In es, this message translates to:
  /// **'Comentario (opcional)'**
  String get commentOptionalLabel;

  /// Botón para enviar la calificación
  ///
  /// In es, this message translates to:
  /// **'Enviar calificación'**
  String get submitRating;

  /// Snackbar de éxito al enviar la calificación
  ///
  /// In es, this message translates to:
  /// **'¡Gracias por tu calificación!'**
  String get ratingThanks;

  /// Título de la pantalla de reseñas de un vendedor
  ///
  /// In es, this message translates to:
  /// **'Reseñas del vendedor'**
  String get vendorReviewsTitle;

  /// Cantidad de reseñas de un vendedor
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 reseña} other{{count} reseñas}}'**
  String reviewsCount(int count);

  /// Estado vacío de la lista de reseñas
  ///
  /// In es, this message translates to:
  /// **'Aún no hay reseñas'**
  String get noReviewsTitle;

  /// Subtítulo del estado vacío de reseñas
  ///
  /// In es, this message translates to:
  /// **'Sé la primera persona en calificar a este vendedor.'**
  String get noReviewsSubtitle;

  /// Acción para reportar un fraude de un vendedor
  ///
  /// In es, this message translates to:
  /// **'Reportar fraude'**
  String get reportFraud;

  /// Botón para reintentar tras un error
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// Cantidad de reportes de precio que respaldan el índice
  ///
  /// In es, this message translates to:
  /// **'{count, plural, =1{1 reporte} other{{count} reportes}}'**
  String reportsCount(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

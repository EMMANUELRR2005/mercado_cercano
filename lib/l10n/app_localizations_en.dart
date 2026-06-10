// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MercadoCercano';

  @override
  String get tagline => 'Market prices, in your pocket';

  @override
  String get phoneInputTitle => 'What\'s your number?';

  @override
  String get phoneInputSubtitle => 'We\'ll send you a verification code';

  @override
  String get sendCode => 'Send code';

  @override
  String get verifyCode => 'Verify code';

  @override
  String get otpInputTitle => 'Enter the code';

  @override
  String get resendCode => 'Resend code';

  @override
  String get iAmBuyer => 'I\'m a Buyer';

  @override
  String get iAmVendor => 'I\'m a Vendor';

  @override
  String get publishProduct => 'Publish product';

  @override
  String get renewAll => 'Renew all';

  @override
  String get markSoldOut => 'Mark as sold out';

  @override
  String get soldOut => 'Sold out';

  @override
  String get priceIndex => 'Price index';

  @override
  String get nearbyVendors => 'Nearby vendors';

  @override
  String get averagePriceInZone => 'Average price in your area';

  @override
  String get reportPrice => 'Report price';

  @override
  String get setAlert => 'Create price alert';

  @override
  String get verifiedVendor => 'Verified Vendor';

  @override
  String get noInternetBanner => 'No connection — showing saved data';

  @override
  String expiresIn(String time) {
    return 'Expires in $time';
  }

  @override
  String get featuredPost => 'Featured Post';

  @override
  String get featured => 'Featured';

  @override
  String get upgradeToProTitle => 'Premium Feature';

  @override
  String upgradeToProSubtitle(String featureName) {
    return 'Access $featureName with the Pro Plan';
  }

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get rateVendorTitle => 'Rate vendor';

  @override
  String get rateVendorQuestion => 'How was your experience with this vendor?';

  @override
  String get commentOptionalLabel => 'Comment (optional)';

  @override
  String get submitRating => 'Submit rating';

  @override
  String get ratingThanks => 'Thanks for your rating!';

  @override
  String get vendorReviewsTitle => 'Vendor reviews';

  @override
  String reviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get noReviewsTitle => 'No reviews yet';

  @override
  String get noReviewsSubtitle => 'Be the first to rate this vendor.';

  @override
  String get reportFraud => 'Report fraud';

  @override
  String get retry => 'Retry';

  @override
  String reportsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports',
      one: '1 report',
    );
    return '$_temp0';
  }
}

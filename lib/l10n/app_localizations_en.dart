// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GlyLens';

  @override
  String get tagline => 'Food Intelligence for Better Decisions';

  @override
  String get splashLoading => 'Loading GlyLens…';

  @override
  String get welcomeTitle => 'Welcome to GlyLens';

  @override
  String get welcomeSubtitle =>
      'Explore evidence-based food intelligence before you sign up.';

  @override
  String get continueAnonymously => 'Continue anonymously';

  @override
  String get signInGoogle => 'Sign in with Google';

  @override
  String get signInApple => 'Sign in with Apple';

  @override
  String get homeTitle => 'Home';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchPlaceholder => 'Search foods (coming in Build Program 2)';

  @override
  String get scanTitle => 'Scan';

  @override
  String get scanPlaceholder =>
      'Barcode scanning arrives in a later build program.';

  @override
  String get historyTitle => 'History';

  @override
  String get historyEmpty => 'Your food history will appear here.';

  @override
  String get compareTitle => 'Compare';

  @override
  String get comparePlaceholder =>
      'Compare foods side by side in a future release.';

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumPlaceholder => 'Premium plans will unlock unlimited scans.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get aboutTitle => 'About GlyLens';

  @override
  String get privacyTitle => 'Privacy Policy';

  @override
  String get termsTitle => 'Terms of Service';

  @override
  String get developerTitle => 'Developer';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get environmentLabel => 'Environment';

  @override
  String get signOut => 'Sign out';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get retry => 'Retry';
}

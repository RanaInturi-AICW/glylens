import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [Locale('en')];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'GlyLens',
      'tagline': 'Food Intelligence for Better Decisions',
      'splashLoading': 'Loading GlyLens…',
      'welcomeTitle': 'Welcome to GlyLens',
      'welcomeSubtitle':
          'Explore evidence-based food intelligence before you sign up.',
      'continueAnonymously': 'Continue anonymously',
      'signInGoogle': 'Sign in with Google',
      'signInApple': 'Sign in with Apple',
      'homeTitle': 'Home',
      'searchTitle': 'Search',
      'searchPlaceholder': 'Search foods (coming in Build Program 2)',
      'scanTitle': 'Scan',
      'scanPlaceholder': 'Barcode scanning arrives in a later build program.',
      'historyTitle': 'History',
      'historyEmpty': 'Your food history will appear here.',
      'compareTitle': 'Compare',
      'comparePlaceholder': 'Compare foods side by side in a future release.',
      'premiumTitle': 'Premium',
      'premiumPlaceholder': 'Premium plans will unlock unlimited scans.',
      'settingsTitle': 'Settings',
      'aboutTitle': 'About GlyLens',
      'privacyTitle': 'Privacy Policy',
      'termsTitle': 'Terms of Service',
      'developerTitle': 'Developer',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'themeSystem': 'System',
      'environmentLabel': 'Environment',
      'signOut': 'Sign out',
      'errorGeneric': 'Something went wrong. Please try again.',
      'retry': 'Retry',
    },
  };

  String _text(String key) =>
      _localizedValues[locale.languageCode]?[key] ?? key;

  String get appTitle => _text('appTitle');
  String get tagline => _text('tagline');
  String get splashLoading => _text('splashLoading');
  String get welcomeTitle => _text('welcomeTitle');
  String get welcomeSubtitle => _text('welcomeSubtitle');
  String get continueAnonymously => _text('continueAnonymously');
  String get signInGoogle => _text('signInGoogle');
  String get signInApple => _text('signInApple');
  String get homeTitle => _text('homeTitle');
  String get searchTitle => _text('searchTitle');
  String get searchPlaceholder => _text('searchPlaceholder');
  String get scanTitle => _text('scanTitle');
  String get scanPlaceholder => _text('scanPlaceholder');
  String get historyTitle => _text('historyTitle');
  String get historyEmpty => _text('historyEmpty');
  String get compareTitle => _text('compareTitle');
  String get comparePlaceholder => _text('comparePlaceholder');
  String get premiumTitle => _text('premiumTitle');
  String get premiumPlaceholder => _text('premiumPlaceholder');
  String get settingsTitle => _text('settingsTitle');
  String get aboutTitle => _text('aboutTitle');
  String get privacyTitle => _text('privacyTitle');
  String get termsTitle => _text('termsTitle');
  String get developerTitle => _text('developerTitle');
  String get themeLight => _text('themeLight');
  String get themeDark => _text('themeDark');
  String get themeSystem => _text('themeSystem');
  String get environmentLabel => _text('environmentLabel');
  String get signOut => _text('signOut');
  String get errorGeneric => _text('errorGeneric');
  String get retry => _text('retry');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      SynchronousFuture(AppLocalizations(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

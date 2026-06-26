import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../core/config/app_config.dart';

/// Firebase options from compile-time configuration.
/// Replace with `flutterfire configure` output for production projects.
class DefaultFirebaseOptions {
  static FirebaseOptions fromConfig(AppConfig config) {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: config.firebaseApiKey,
        appId: config.firebaseAppId,
        messagingSenderId: config.firebaseMessagingSenderId,
        projectId: config.firebaseProjectId,
        authDomain: '${config.firebaseProjectId}.firebaseapp.com',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: config.firebaseApiKey,
          appId: config.firebaseAppId,
          messagingSenderId: config.firebaseMessagingSenderId,
          projectId: config.firebaseProjectId,
        );
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return FirebaseOptions(
          apiKey: config.firebaseApiKey,
          appId: config.firebaseAppId,
          messagingSenderId: config.firebaseMessagingSenderId,
          projectId: config.firebaseProjectId,
          iosBundleId: 'com.glylens.app',
        );
      default:
        return FirebaseOptions(
          apiKey: config.firebaseApiKey,
          appId: config.firebaseAppId,
          messagingSenderId: config.firebaseMessagingSenderId,
          projectId: config.firebaseProjectId,
        );
    }
  }
}

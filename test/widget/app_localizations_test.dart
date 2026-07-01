import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glylens/l10n/app_localizations.dart';

void main() {
  testWidgets('AppLocalizations loads English strings', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [AppLocalizations.delegate],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context);
            return Text(l10n.appTitle);
          },
        ),
      ),
    );

    expect(find.text('GlyLens'), findsOneWidget);
  });
}

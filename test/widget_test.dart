// Smoke test — with no face chosen, FamilyHub opens the setup screen.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_hub/app.dart';
import 'package:family_hub/core/device/hub_face_store.dart';
import 'package:family_hub/features/setup/setup_screen.dart';

void main() {
  testWidgets('setup-first: no stored face → setup screen', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const FamilyHubApp(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(SetupScreen), findsOneWidget);
    expect(find.text('Чьё это устройство?'), findsOneWidget);
    expect(find.text('Родитель'), findsOneWidget);
    expect(find.text('Тогжан'), findsOneWidget);
  });

  testWidgets('stored parent face → not the setup screen', (tester) async {
    SharedPreferences.setMockInitialValues({'hub_face': 'parent'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const FamilyHubApp(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(SetupScreen), findsNothing);
    expect(find.text('Лицо родителя'), findsOneWidget);
  });
}

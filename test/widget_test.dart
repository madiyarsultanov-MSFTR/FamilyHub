// Smoke test — with no face chosen, FamilyHub opens the setup screen.

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:family_hub/app.dart';
import 'package:family_hub/core/device/hub_face_store.dart';
import 'package:family_hub/features/setup/setup_screen.dart';

void main() {
  // FamilyHub is a landscape tablet build; test at a representative surface.
  void useTabletSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('setup-first: no stored face → setup screen', (tester) async {
    useTabletSurface(tester);
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
    useTabletSurface(tester);
    SharedPreferences.setMockInitialValues({'hub_face': 'parent'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const FamilyHubApp(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(SetupScreen), findsNothing);
    expect(find.text('Сегодня'), findsOneWidget);
    expect(find.text('Дети'), findsOneWidget);
  });

  testWidgets('stored child face → greeting for that child', (tester) async {
    useTabletSurface(tester);
    SharedPreferences.setMockInitialValues({'hub_face': 'child:togzhan'});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const FamilyHubApp(),
    ));
    await tester.pumpAndSettle();

    expect(find.byType(SetupScreen), findsNothing);
    expect(find.textContaining('Привет, Тогжан'), findsOneWidget);
  });
}

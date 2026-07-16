// Smoke test — FamilyHub boots to the ambient surface.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:family_hub/app.dart';
import 'package:family_hub/features/ambient/ambient_screen.dart';

void main() {
  testWidgets('boots to the ambient screen and shows the child pulse',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FamilyHubApp()));
    await tester.pumpAndSettle();

    expect(find.byType(AmbientScreen), findsOneWidget);
    expect(find.text('Тогжан'), findsOneWidget);
  });
}

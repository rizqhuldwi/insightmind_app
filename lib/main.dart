import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pam_teori/src/app.dart';

void main() {
  testWidgets('FAB adds a Chip to the HomePage', (WidgetTester tester) async {
    // Build the app inside a ProviderScope (as the app expects).
    // Build the app (InsightMindApp already manages providers if needed).
    await tester.pumpWidget(const InsightMindApp());

    // The HomePage shows a description text.

    // Initially there should be no Chip widgets (no answers yet).
    expect(find.byType(Chip), findsNothing);

    // Tap the FAB (add) and rebuild.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // After tapping, a Chip representing the new answer should appear.
    expect(find.byType(Chip), findsOneWidget);
  });
}
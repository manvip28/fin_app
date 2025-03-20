import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fin_app/main.dart';

void main() {
  testWidgets('Add Transaction button is present and tappable', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify the button is present - adjust the finder to match how your button appears
    // You might need to use find.byIcon(), find.byKey(), or another finder that matches your UI
    expect(find.text('Add Transaction'), findsOneWidget);

    // Tap the button and trigger a frame
    await tester.tap(find.text('Add Transaction'));
    await tester.pumpAndSettle(); // Use pumpAndSettle to wait for animations

    expect(find.text('New Transaction'), findsOneWidget);
    // Or if it navigates to a new screen:
  });
}
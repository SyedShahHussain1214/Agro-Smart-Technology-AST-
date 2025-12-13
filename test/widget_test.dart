// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:agro_smart_tech/main.dart';

void main() {
  testWidgets('App shows header text', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    // The app initially shows the auth screen. Verify the OTP send button
    expect(find.text('OTP بھیجیں'), findsOneWidget);
    // Verify the login button is present
    expect(find.text('لاگ ان'), findsOneWidget);
  });
}

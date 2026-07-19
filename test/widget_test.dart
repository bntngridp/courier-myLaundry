import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:courier_mylaundry/main.dart';

void main() {
  testWidgets('Courier App Initial UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CourierApp());

    // Verify that the welcome text is displayed.
    expect(find.text('Selamat Datang, Kurir! 🦅'), findsOneWidget);
    expect(find.text('Masuk Ke Akun Kurir'), findsOneWidget);

    // Tap the button and trigger a frame.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify that the login info text isn't directly on the screen but shows somewhere,
    // or just check that it is found.
  });
}

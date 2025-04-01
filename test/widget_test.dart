import 'package:chat_app/screens/view/pages/Login-Signup/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginPage test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));

    // Verify that the login page is displayed.
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);

    // Enter email and password.
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password');

    // Tap the login button.
    await tester.tap(find.byType(ElevatedButton));

    // Verify that the login button is tapped.
    // You can add more assertions here to verify the behavior of the login button.
  });
}
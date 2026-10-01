import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ez_loans/core/validators.dart';
import 'package:ez_loans/main.dart';
import 'package:ez_loans/screens/forgot_password_screen.dart';
import 'package:ez_loans/screens/login_screen.dart';
import 'package:ez_loans/screens/signup_screen.dart';

void main() {
  group('Validators tests', () {
    test('email validation', () {
      expect(Validators.email(''), 'Email address is required');
      expect(Validators.email('abc'), isNotNull);
      expect(Validators.email('a@b'), isNotNull);
      expect(Validators.email('user@example.com'), isNull);
    });

    test('password match', () {
      expect(Validators.confirmPassword('x', 'y'), 'Passwords do not match');
      expect(Validators.confirmPassword('secret1', 'secret1'), isNull);
    });

    test('phone validation', () {
      expect(Validators.phone(''), isNotNull);
      expect(Validators.phone('12345'), isNotNull);
      expect(Validators.phone('+91 98765 43210'), isNull);
    });
  });

  group('Screen Widget Tests', () {
    testWidgets('LoginScreen renders and validates fields based on user interaction',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: LoginScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('back'), findsOneWidget);
      expect(find.text('Email address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Initially no errors
      expect(find.text('Email address is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);

      // Tap Login without filling form -> both invalid fields show errors on submit
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.text('Email address is required'), findsOneWidget);
      expect(find.text('Password is required'), findsOneWidget);

      // Correcting email clears email error immediately
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'user@example.com');
      await tester.pumpAndSettle();
      expect(find.text('Email address is required'), findsNothing);
      expect(find.text('Password is required'), findsOneWidget);

      // Correcting password clears password error immediately
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pumpAndSettle();
      expect(find.text('Password is required'), findsNothing);
    });

    testWidgets('ForgotPasswordScreen renders, validates, and simulates reset link',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Forgot'), findsOneWidget);
      expect(find.text('Password?'), findsOneWidget);
      expect(find.text('Send reset link'), findsOneWidget);
      expect(find.text('Back to Login'), findsOneWidget);

      // Initially no errors
      expect(find.text('Email address is required'), findsNothing);

      // Tap Send reset link when empty
      await tester.tap(find.text('Send reset link'));
      await tester.pumpAndSettle();
      expect(find.text('Email address is required'), findsOneWidget);

      // Enter invalid email
      await tester.enterText(
          find.widgetWithText(TextFormField, ''), 'invalid-email');
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email address'), findsOneWidget);

      // Enter valid email
      await tester.enterText(
          find.widgetWithText(TextFormField, 'invalid-email'), 'user@example.com');
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email address'), findsNothing);

      // Submit
      await tester.tap(find.text('Send reset link'));
      await tester.pump(); // Show loading state

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Fast forward past the fake network delay
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Reset link sent!'), findsOneWidget);
    });

    testWidgets('SignUpScreen validates checkbox-conditional and user interaction',
        (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: SignUpScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Create'), findsOneWidget);
      expect(find.text('Account'), findsOneWidget);
      expect(find.text('Full name'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);

      // Initially no errors on any untouched field
      expect(find.text('Full name is required'), findsNothing);
      expect(find.text('Email address is required'), findsNothing);
      expect(find.text('Phone number is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Please confirm your password'), findsNothing);
      expect(find.text('You must agree to the terms'), findsNothing);

      final textFields = find.byType(TextFormField);

      // User enters invalid email directly -> shows email error
      await tester.enterText(textFields.at(1), 'invalid-mail');
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email address'), findsOneWidget);
      // Untouched fields still have no errors
      expect(find.text('Full name is required'), findsNothing);
      expect(find.text('Phone number is required'), findsNothing);

      // User clicks Submit without checking checkbox:
      // Should show checkbox error and error for entered field (email), but NOT untouched fields!
      await tester.ensureVisible(find.text('Sign Up'));
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      expect(find.text('You must agree to the terms'), findsOneWidget);
      expect(find.text('Please enter a valid email address'), findsOneWidget);
      expect(find.text('Full name is required'), findsNothing);
      expect(find.text('Phone number is required'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(find.text('Please confirm your password'), findsNothing);

      // User corrects email -> error disappears
      await tester.enterText(textFields.at(1), 'jane@example.com');
      await tester.pumpAndSettle();
      expect(find.text('Please enter a valid email address'), findsNothing);

      // User enters mismatched passwords
      await tester.enterText(textFields.at(3), 'secret123');
      await tester.enterText(textFields.at(4), 'different456');
      await tester.pumpAndSettle();
      expect(find.text('Passwords do not match'), findsOneWidget);

      // User fixes confirm password -> error disappears immediately
      await tester.enterText(textFields.at(4), 'secret123');
      await tester.pumpAndSettle();
      expect(find.text('Passwords do not match'), findsNothing);

      // Now user checks the checkbox and clicks Submit -> validates ALL fields
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();
      expect(find.text('You must agree to the terms'), findsNothing);

      await tester.ensureVisible(find.text('Sign Up'));
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle();

      // Now empty fields (Name and Phone) show their required errors
      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Phone number is required'), findsOneWidget);

      // Enter Name and Phone -> errors clear
      await tester.enterText(textFields.at(0), 'Jane Doe');
      await tester.enterText(textFields.at(2), '+12345678901');
      await tester.pumpAndSettle();
      expect(find.text('Full name is required'), findsNothing);
      expect(find.text('Phone number is required'), findsNothing);

      // Tap Sign Up with all valid + checkbox checked -> proceeds to submit
      await tester.ensureVisible(find.text('Sign Up'));
      await tester.tap(find.text('Sign Up'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
    });

    testWidgets('App navigates between screens smoothly', (tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(const EzLoansApp());
      await tester.pumpAndSettle();

      // Go to Forgot Password
      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();
      expect(find.text('Password?'), findsOneWidget);

      // Go back to Login
      await tester.tap(find.text('Back to Login'));
      await tester.pumpAndSettle();
      expect(find.text('Welcome'), findsOneWidget);

      // Go to Sign Up
      await tester.ensureVisible(find.text('Sign up'));
      await tester.tap(find.text('Sign up'));
      await tester.pumpAndSettle();
      expect(find.text('Create'), findsOneWidget);

      // Go back to Login via back button
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}



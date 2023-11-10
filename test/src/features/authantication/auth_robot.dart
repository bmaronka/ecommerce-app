import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class AuthRobot {
  const AuthRobot(this.tester);

  final WidgetTester tester;

  Future<void> openEmailPasswordSignInScreen() async {
    final finder = find.byKey(MoreMenuButton.signInKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  //EmailPasswordSignInContents
  Future<void> pumpEmailPasswordSignInContents({
    required FakeAuthRepository authRepository,
    required EmailPasswordSignInFormType formType,
    VoidCallback? onSignedIn,
  }) =>
      tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepository),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: EmailPasswordSignInContents(
                formType: formType,
                onSignedIn: onSignedIn,
              ),
            ),
          ),
        ),
      );

  Future<void> tapEmailAndPasswordSubmitButton() async {
    await _findAndTapEmailAndPasswordSubmitButton();
    await tester.pump();
  }

  Future<void> tapEmailAndPasswordSubmitButtonAndSettle() async {
    await _findAndTapEmailAndPasswordSubmitButton();
    await tester.pumpAndSettle();
  }

  Future<void> _findAndTapEmailAndPasswordSubmitButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
  }

  Future<void> enterAndSubmitEmailAndPassword() async {
    await enterEmail('test@test.com');
    await enterPassword('test12345');
    await tapEmailAndPasswordSubmitButtonAndSettle();
  }

  Future<void> openAccountScreen() async {
    final finder = find.byKey(MoreMenuButton.accountKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tapOnNeedAnAccountButton() async {
    final needAnAccountButton = find.text('Need an account? Register');
    expect(needAnAccountButton, findsOneWidget);
    await tester.tap(needAnAccountButton);
    await tester.pump();
  }

  void expectCreateAnAccountSubmitButton() {
    final createAnAccountSubmitButton = find.text('Create an account');
    expect(createAnAccountSubmitButton, findsOneWidget);
  }

  void expectEmptyEmailValidationErrorFound() {
    final emptyEmailValidationError = find.text('Email can\'t be empty');
    expect(emptyEmailValidationError, findsOneWidget);
  }

  void expectEmptyPasswordValidationErrorFound() {
    final emptyPasswordValidationError = find.text('Password can\'t be empty');
    expect(emptyPasswordValidationError, findsOneWidget);
  }

  void expectInvalidEmailValidationErrorFound() {
    final invalidEmailValidationError = find.text('Invalid email');
    expect(invalidEmailValidationError, findsOneWidget);
  }

  void expectPasswordIsTooShortValidationErrorFound() {
    final passwordIsTooShortValidationError = find.text('Password is too short');
    expect(passwordIsTooShortValidationError, findsOneWidget);
  }

  Future<void> tapOnHaveAnAccountButton() async {
    final haveAnAccountButton = find.text('Have an account? Sign in');
    expect(haveAnAccountButton, findsOneWidget);
    await tester.tap(haveAnAccountButton);
    await tester.pump();
  }

  void expectSignInSubmitButton() {
    final signInSubmitButton = find.text('Sign in');
    expect(signInSubmitButton, findsOneWidget);
  }

  void expectEmailAndPasswordFieldsFound() {
    final emailField = find.byKey(EmailPasswordSignInScreen.emailKey);
    expect(emailField, findsOneWidget);
    final passwordField = find.byKey(EmailPasswordSignInScreen.passwordKey);
    expect(passwordField, findsOneWidget);
  }

  //AccountScreen
  Future<void> pumpAccountScreen({FakeAuthRepository? authRepository}) => tester.pumpWidget(
        ProviderScope(
          overrides: [
            if (authRepository != null) authRepositoryProvider.overrideWithValue(authRepository),
          ],
          child: MaterialApp(
            home: AccountScreen(),
          ),
        ),
      );

  Future<void> tapLogoutButton() async {
    final logoutButton = find.text('Logout');
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectLogoutDialogFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsOneWidget);
  }

  Future<void> tapCancelButton() async {
    final cancelButton = find.text('Cancel');
    expect(cancelButton, findsOneWidget);
    await tester.tap(cancelButton);
    await tester.pump();
  }

  void expectLogoutDialogNotFound() {
    final dialogTitle = find.text('Are you sure?');
    expect(dialogTitle, findsNothing);
  }

  Future<void> tapDialogLogoutButton() async {
    final logoutButton = find.byKey(kDialogDefaultKey);
    expect(logoutButton, findsOneWidget);
    await tester.tap(logoutButton);
    await tester.pump();
  }

  void expectErrorAlertFound() {
    final finder = find.text('Error');
    expect(finder, findsOneWidget);
  }

  void expectErrorAlertNotFound() {
    final finder = find.text('Error');
    expect(finder, findsNothing);
  }

  void expectCircularProgressIndicator() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }
}

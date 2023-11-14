import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';
import '../../auth_robot.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = '123123123';

  late MockFakeAuthRepository mockFakeAuthRepository;

  setUp(() => mockFakeAuthRepository = MockFakeAuthRepository());

  group(
    'sing in',
    () {
      testWidgets(
        '''
        Given formType is signIn
        When tap on the sign-in button
        Then signInWithEmailAndPassword is not called
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await robot.tapEmailAndPasswordSubmitButton();

          verifyNever(mockFakeAuthRepository.signInWithEmailAndPassword(any, any));
        },
      );

      testWidgets(
        '''
        Given formType is signIn
        When enter valid email and password
        And tap on sign-in button
        Then signInWithEmailAndPassword is called
        And onSignedIn callback is called
        And error alert is not shown
        ''',
        (tester) async {
          bool didSignIn = false;
          final robot = AuthRobot(tester);

          when(mockFakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword))
              .thenAnswer((_) => Future.value());

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
            onSignedIn: () => didSignIn = true,
          );
          await robot.enterEmail(testEmail);
          await robot.enterPassword(testPassword);
          await robot.tapEmailAndPasswordSubmitButton();

          verify(mockFakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword)).called(1);
          robot.expectErrorAlertNotFound();
          expect(didSignIn, true);
        },
      );

      testWidgets(
        '''
        Given formType is signIn
        When tap on need an account button
        And updateFormType called
        Then formType is changed to register
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await robot.tapOnNeedAnAccountButton();

          robot.expectCreateAnAccountSubmitButton();
        },
      );

      testWidgets(
        '''
        Given formType is signIn
        When email and password are empty
        Then empty errors are shown
        And signInWithEmailAndPassword is not called
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await robot.tapEmailAndPasswordSubmitButton();

          robot.expectEmptyEmailValidationErrorFound();
          robot.expectEmptyPasswordValidationErrorFound();
          verifyNever(mockFakeAuthRepository.signInWithEmailAndPassword(any, any));
        },
      );

      testWidgets(
        '''
        Given formType is signIn
        When email is not email form
        Then inavalid email error is shown
        And signInWithEmailAndPassword is not called
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await robot.enterEmail('test');
          await robot.tapEmailAndPasswordSubmitButton();

          robot.expectInvalidEmailValidationErrorFound();
          verifyNever(mockFakeAuthRepository.signInWithEmailAndPassword(any, any));
        },
      );

      testWidgets(
        '''
        Given formType is signIn
        When signInWithEmailAndPassword fails
        Then signInWithEmailAndPassword is called once
        And error dialog is shown
        ''',
        (tester) async {
          final robot = AuthRobot(tester);
          final exception = Exception('test');

          when(mockFakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword)).thenThrow(exception);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );
          await robot.enterEmail(testEmail);
          await robot.enterPassword(testPassword);
          await robot.tapEmailAndPasswordSubmitButton();

          verify(mockFakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword)).called(1);
          robot.expectErrorAlertFound();
        },
      );

      testWidgets(
        '''
        Given formType is signIn
        When signInWithEmailAndPassword is processing
        Then signInWithEmailAndPassword is called once
        And loading indicator is shown
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          when(mockFakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword))
              .thenAnswer((_) => Future.delayed(const Duration(seconds: 1)));

          await tester.runAsync(() async {
            await robot.pumpEmailPasswordSignInContents(
              authRepository: mockFakeAuthRepository,
              formType: EmailPasswordSignInFormType.signIn,
            );
            await robot.enterEmail(testEmail);
            await robot.enterPassword(testPassword);
            await robot.tapEmailAndPasswordSubmitButton();
          });

          verify(mockFakeAuthRepository.signInWithEmailAndPassword(testEmail, testPassword)).called(1);
          robot.expectCircularProgressIndicator();
        },
      );
    },
  );

  group(
    'register',
    () {
      testWidgets(
        '''
        Given formType is register
        When tap on the register button
        Then signInWithEmailAndPassword is not called
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await robot.tapEmailAndPasswordSubmitButton();

          verifyNever(mockFakeAuthRepository.createUserWithEmailAndPassword(any, any));
        },
      );

      testWidgets(
        '''
        Given formType is register
        When enter valid email and password
        And tap on register button
        Then createUserWithEmailAndPassword is called
        And onSignedIn callback is called
        And error alert is not shown
        ''',
        (tester) async {
          bool didRegister = false;
          final robot = AuthRobot(tester);

          when(mockFakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword))
              .thenAnswer((_) => Future.value());

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
            onSignedIn: () => didRegister = true,
          );
          await robot.enterEmail(testEmail);
          await robot.enterPassword(testPassword);
          await robot.tapEmailAndPasswordSubmitButton();

          verify(mockFakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword)).called(1);
          robot.expectErrorAlertNotFound();
          expect(didRegister, true);
        },
      );

      testWidgets(
        '''
        Given formType is register
        When tap on have an account button
        And updateFormType called
        Then formType is changed to sign in
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await robot.tapOnHaveAnAccountButton();

          robot.expectSignInSubmitButton();
        },
      );

      testWidgets(
        '''
        Given formType is register
        When email and password are empty
        Then empty errors are shown
        And createUserWithEmailAndPassword is not called
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await robot.tapEmailAndPasswordSubmitButton();

          robot.expectEmptyEmailValidationErrorFound();
          robot.expectEmptyPasswordValidationErrorFound();
          verifyNever(mockFakeAuthRepository.createUserWithEmailAndPassword(any, any));
        },
      );

      testWidgets(
        '''
        Given formType is register
        When email is not email form
        And password is too short
        Then inavalid email error is shown
        And password is too short error is shown
        And createUserWithEmailAndPassword is not called
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await robot.enterEmail('test');
          await robot.enterPassword('test');
          await robot.tapEmailAndPasswordSubmitButton();

          robot.expectInvalidEmailValidationErrorFound();
          robot.expectPasswordIsTooShortValidationErrorFound();
          verifyNever(mockFakeAuthRepository.createUserWithEmailAndPassword(any, any));
        },
      );

      testWidgets(
        '''
        Given formType is register
        When createUserWithEmailAndPassword fails
        Then createUserWithEmailAndPassword is called once
        And error dialog is shown
        ''',
        (tester) async {
          final robot = AuthRobot(tester);
          final exception = Exception('test');

          when(mockFakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword)).thenThrow(exception);

          await robot.pumpEmailPasswordSignInContents(
            authRepository: mockFakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );
          await robot.enterEmail(testEmail);
          await robot.enterPassword(testPassword);
          await robot.tapEmailAndPasswordSubmitButton();

          verify(mockFakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword)).called(1);
          robot.expectErrorAlertFound();
        },
      );

      testWidgets(
        '''
        Given formType is register
        When createUserWithEmailAndPassword is processing
        Then createUserWithEmailAndPassword is called once
        And loading indicator is shown
        ''',
        (tester) async {
          final robot = AuthRobot(tester);

          when(mockFakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword))
              .thenAnswer((_) => Future.delayed(const Duration(seconds: 1)));

          await tester.runAsync(() async {
            await robot.pumpEmailPasswordSignInContents(
              authRepository: mockFakeAuthRepository,
              formType: EmailPasswordSignInFormType.register,
            );
            await robot.enterEmail(testEmail);
            await robot.enterPassword(testPassword);
            await robot.tapEmailAndPasswordSubmitButton();
          });

          verify(mockFakeAuthRepository.createUserWithEmailAndPassword(testEmail, testPassword)).called(1);
          robot.expectCircularProgressIndicator();
        },
      );
    },
  );
}

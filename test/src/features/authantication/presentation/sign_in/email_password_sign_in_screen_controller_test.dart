@Timeout(const Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_screen_controller.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;

  final exception = Exception('Connection failure');
  const email = 'test@test.com';
  const password = '123123123';

  setUp(() => fakeAuthRepository = MockFakeAuthRepository());

  group(
    'submit',
    () {
      test(
        '''
        Given formType is signIn
        When signInWithEmailAndPassword succeeds
        Then return true
        And state is AsyncData
        ''',
        () async {
          final controller = EmailPasswordSignInScreenController(
            fakeAuthRepository: fakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );

          when(fakeAuthRepository.signInWithEmailAndPassword(email, password)).thenAnswer((_) => Future.value());

          expect(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading(),
              ),
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncData<void>(null),
              ),
            ]),
          );

          final result = await controller.submit(email, password);

          expect(result, true);
          verify(fakeAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
        },
      );

      test(
        '''
        Given formType is signIn
        When signInWithEmailAndPassword fails
        Then return false
        And state is AsyncError
        ''',
        () async {
          final controller = EmailPasswordSignInScreenController(
            fakeAuthRepository: fakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );

          when(fakeAuthRepository.signInWithEmailAndPassword(email, password)).thenThrow(exception);

          expect(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.signIn,
                value: const AsyncLoading(),
              ),
              predicate<EmailPasswordSignInState>(
                (value) {
                  expect(value.formType, EmailPasswordSignInFormType.signIn);
                  expect(value.value.hasError, true);
                  return true;
                },
              ),
            ]),
          );

          final result = await controller.submit(email, password);

          expect(result, false);
          verify(fakeAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
        },
      );

      test(
        '''
        Given formType is register
        When signInWithEmailAndPassword succeeds
        Then return true
        And state is AsyncData
        ''',
        () async {
          final controller = EmailPasswordSignInScreenController(
            fakeAuthRepository: fakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );

          when(fakeAuthRepository.createUserWithEmailAndPassword(email, password)).thenAnswer((_) => Future.value());

          expect(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading(),
              ),
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncData<void>(null),
              ),
            ]),
          );

          final result = await controller.submit(email, password);

          expect(result, true);
          verify(fakeAuthRepository.createUserWithEmailAndPassword(email, password)).called(1);
        },
      );

      test(
        '''
        Given formType is register
        When signInWithEmailAndPassword fails
        Then return false
        And state is AsyncError
        ''',
        () async {
          final controller = EmailPasswordSignInScreenController(
            fakeAuthRepository: fakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );

          when(fakeAuthRepository.createUserWithEmailAndPassword(email, password)).thenThrow(exception);

          expect(
            controller.stream,
            emitsInOrder([
              EmailPasswordSignInState(
                formType: EmailPasswordSignInFormType.register,
                value: const AsyncLoading(),
              ),
              predicate<EmailPasswordSignInState>(
                (value) {
                  expect(value.formType, EmailPasswordSignInFormType.register);
                  expect(value.value.hasError, true);
                  return true;
                },
              ),
            ]),
          );

          final result = await controller.submit(email, password);

          expect(result, false);
          verify(fakeAuthRepository.createUserWithEmailAndPassword(email, password)).called(1);
        },
      );
    },
  );

  group(
    'updateFormType',
    () {
      test(
        '''
        Given formType is signIn
        When called with register
        Then state.formType is register
        ''',
        () {
          final controller = EmailPasswordSignInScreenController(
            fakeAuthRepository: fakeAuthRepository,
            formType: EmailPasswordSignInFormType.signIn,
          );

          controller.updateFormType(EmailPasswordSignInFormType.register);

          expect(
            controller.state,
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: AsyncData<void>(null),
            ),
          );
        },
      );

      test(
        '''
        Given formType is register
        When called with signIn
        Then state.formType is signIn
        ''',
        () {
          final controller = EmailPasswordSignInScreenController(
            fakeAuthRepository: fakeAuthRepository,
            formType: EmailPasswordSignInFormType.register,
          );

          controller.updateFormType(EmailPasswordSignInFormType.signIn);

          expect(
            controller.state,
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: AsyncData<void>(null),
            ),
          );
        },
      );
    },
  );
}

@Timeout(const Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;

  final exception = Exception('Connection failure');
  const email = 'test@test.com';
  const password = '123123123';
  const testFormType = EmailPasswordSignInFormType.signIn;

  setUp(() => fakeAuthRepository = MockFakeAuthRepository());

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group(
    'EmailPasswordSignInController',
    () {
      test(
        'sign in success',
        () async {
          final container = makeProviderContainer();
          final controller = container.read(emailPasswordSignInControllerProvider.notifier);

          when(fakeAuthRepository.signInWithEmailAndPassword(email, password)).thenAnswer((_) => Future.value());

          expect(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              const AsyncData<void>(null),
            ]),
          );

          final result = await controller.submit(
            email: email,
            password: password,
            formType: testFormType,
          );

          expect(result, true);
          verify(fakeAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
        },
      );

      test(
        'sign in failure',
        () async {
          final container = makeProviderContainer();
          final controller = container.read(emailPasswordSignInControllerProvider.notifier);

          when(fakeAuthRepository.signInWithEmailAndPassword(email, password)).thenThrow(exception);

          expect(
            controller.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((state) {
                expect(state.hasError, true);
                return true;
              }),
            ]),
          );

          final result = await controller.submit(
            email: email,
            password: password,
            formType: testFormType,
          );

          expect(result, false);
          verify(fakeAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
        },
      );
    },
  );
}

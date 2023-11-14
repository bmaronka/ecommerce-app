@Timeout(const Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.dart';
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
          final listener = Listener();
          container.listen(
            emailPasswordSignInScreenControllerProvider,
            listener,
            fireImmediately: true,
          );
          when(fakeAuthRepository.signInWithEmailAndPassword(email, password)).thenAnswer((_) => Future.value());

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          final controller = container.read(emailPasswordSignInScreenControllerProvider.notifier);
          final result = await controller.submit(
            email: email,
            password: password,
            formType: testFormType,
          );

          expect(result, true);
          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), data),
          ]);
          verifyNoMoreInteractions(listener);
          verify(fakeAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
        },
      );

      test(
        'sign in failure',
        () async {
          final container = makeProviderContainer();
          final listener = Listener();
          container.listen(
            emailPasswordSignInScreenControllerProvider,
            listener,
            fireImmediately: true,
          );
          when(fakeAuthRepository.signInWithEmailAndPassword(email, password)).thenThrow(exception);

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          final controller = container.read(emailPasswordSignInScreenControllerProvider.notifier);
          final result = await controller.submit(
            email: email,
            password: password,
            formType: testFormType,
          );

          expect(result, false);
          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(fakeAuthRepository.signInWithEmailAndPassword(email, password)).called(1);
        },
      );
    },
  );
}

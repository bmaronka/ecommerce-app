@Timeout(const Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.dart';
import '../../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;

  final exception = Exception('Connection failure');

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

  test(
    'initial state is AsyncValue.data',
    () {
      final container = makeProviderContainer();
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, AsyncData<void>(null)));
      verifyNoMoreInteractions(listener);
      verifyNever(fakeAuthRepository.signOut());
    },
  );

  test(
    'signOut success',
    () async {
      final container = makeProviderContainer();
      final listener = Listener();
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      when(fakeAuthRepository.signOut()).thenAnswer((_) => Future.value());

      const data = AsyncData<void>(null);
      verify(listener(null, data));

      final controller = container.read(accountScreenControllerProvider.notifier);
      await controller.signOut();

      verifyInOrder([
        listener(data, argThat(isA<AsyncLoading>())),
        listener(argThat(isA<AsyncLoading>()), data),
      ]);
      verifyNoMoreInteractions(listener);
      verify(fakeAuthRepository.signOut()).called(1);
    },
  );

  test(
    'signOut failure',
    () async {
      final container = makeProviderContainer();
      final listener = Listener();
      container.listen(
        accountScreenControllerProvider,
        listener,
        fireImmediately: true,
      );
      when(fakeAuthRepository.signOut()).thenThrow(exception);

      const data = AsyncData<void>(null);
      verify(listener(null, data));

      final controller = container.read(accountScreenControllerProvider.notifier);
      await controller.signOut();

      verifyInOrder([
        listener(data, argThat(isA<AsyncLoading>())),
        listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
      ]);
      verifyNoMoreInteractions(listener);
      verify(fakeAuthRepository.signOut()).called(1);
    },
  );
}

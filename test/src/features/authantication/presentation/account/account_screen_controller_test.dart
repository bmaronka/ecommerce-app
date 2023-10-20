@Timeout(const Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;

  late AccountScreenController accountScreenController;

  final exception = Exception('Connection failure');

  setUp(() {
    fakeAuthRepository = MockFakeAuthRepository();
    accountScreenController = AccountScreenController(fakeAuthRepository);
  });

  test(
    'initial state is AsyncValue.data',
    () {
      expect(accountScreenController.state, AsyncData<void>(null));
    },
  );

  test(
    'signOut success',
    () async {
      when(fakeAuthRepository.signOut()).thenAnswer((_) => Future.value());

      expect(
        accountScreenController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ]),
      );

      await accountScreenController.signOut();

      verify(fakeAuthRepository.signOut()).called(1);
    },
  );

  test(
    'signOut failure',
    () async {
      when(fakeAuthRepository.signOut()).thenThrow(exception);

      expect(
        accountScreenController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );

      await accountScreenController.signOut();

      verify(fakeAuthRepository.signOut()).called(1);
    },
  );
}

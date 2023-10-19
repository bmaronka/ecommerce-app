import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountScreenController extends StateNotifier<AsyncValue> {
  AccountScreenController(this._fakeAuthRepository) : super(const AsyncValue.data(null));

  final FakeAuthRepository _fakeAuthRepository;

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_fakeAuthRepository.signOut);
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<AccountScreenController, AsyncValue>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return AccountScreenController(authRepository);
});

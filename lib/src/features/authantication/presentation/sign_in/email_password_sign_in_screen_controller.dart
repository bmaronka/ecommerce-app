import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInScreenController extends StateNotifier<AsyncValue<void>> {
  EmailPasswordSignInScreenController({required this.fakeAuthRepository}) : super(const AsyncData<void>(null));

  final FakeAuthRepository fakeAuthRepository;

  Future<bool> submit({
    required String email,
    required String password,
    required EmailPasswordSignInFormType formType,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() => _authenticate(email, password, formType));

    return state.hasError == false;
  }

  Future<void> _authenticate(String email, String password, EmailPasswordSignInFormType formType) {
    switch (formType) {
      case EmailPasswordSignInFormType.signIn:
        return fakeAuthRepository.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return fakeAuthRepository.createUserWithEmailAndPassword(email, password);
    }
  }
}

final emailPasswordSignInControllerProvider =
    StateNotifierProvider.autoDispose<EmailPasswordSignInScreenController, AsyncValue<void>>(
  (ref) => EmailPasswordSignInScreenController(fakeAuthRepository: ref.watch(authRepositoryProvider)),
);

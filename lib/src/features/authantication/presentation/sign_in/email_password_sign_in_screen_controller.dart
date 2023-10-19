import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInScreenController extends StateNotifier<EmailPasswordSignInState> {
  EmailPasswordSignInScreenController({
    required EmailPasswordSignInFormType formType,
    required this.fakeAuthRepository,
  }) : super(EmailPasswordSignInState(formType: formType));

  final FakeAuthRepository fakeAuthRepository;

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(value: const AsyncValue.loading());

    final value = await AsyncValue.guard(() => _authenticate(email, password));
    state = state.copyWith(value: value);

    return !value.hasError;
  }

  Future<void> _authenticate(String email, String password) {
    switch (state.formType) {
      case EmailPasswordSignInFormType.signIn:
        return fakeAuthRepository.signInWithEmailAndPassword(email, password);
      case EmailPasswordSignInFormType.register:
        return fakeAuthRepository.createUserWithEmailAndPassword(email, password);
    }
  }

  void updateFormType(EmailPasswordSignInFormType formType) => state = state.copyWith(formType: formType);
}

final emailPasswordSignInScreenControllerProvider = StateNotifierProvider.autoDispose
    .family<EmailPasswordSignInScreenController, EmailPasswordSignInState, EmailPasswordSignInFormType>(
        (ref, formType) {
  final authRepo = ref.watch(authRepositoryProvider);

  return EmailPasswordSignInScreenController(
    fakeAuthRepository: authRepo,
    formType: formType,
  );
});

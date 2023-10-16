import 'package:ecommerce_app/src/features/sign_in/string_validators.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';

enum EmailPasswordSignInFormType { signIn, register }

mixin EmailAndPasswordValidators {
  final StringValidator emailSubmitValidator = EmailSubmitRegexValidator();
  final StringValidator passwordRegisterSubmitValidator = MinLengthStringValidator(8);
  final StringValidator passwordSignInSubmitValidator = NonEmptyStringValidator();
}

class EmailPasswordSignInState with EmailAndPasswordValidators {
  EmailPasswordSignInState({
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
  });

  final EmailPasswordSignInFormType formType;
  final bool isLoading;

  EmailPasswordSignInState copyWith({
    EmailPasswordSignInFormType? formType,
    bool? isLoading,
  }) =>
      EmailPasswordSignInState(
        formType: formType ?? this.formType,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  String toString() => 'EmailPasswordSignInState(formType: $formType, isLoading: $isLoading)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmailPasswordSignInState && other.formType == formType && other.isLoading == isLoading;
  }

  @override
  int get hashCode => formType.hashCode ^ isLoading.hashCode;
}

extension EmailPasswordSignInStateX on EmailPasswordSignInState {
  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Password (8+ characters)'.hardcoded;
    } else {
      return 'Password'.hardcoded;
    }
  }

  String get primaryButtonText {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Create an account'.hardcoded;
    } else {
      return 'Sign in'.hardcoded;
    }
  }

  String get secondaryButtonText {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Have an account? Sign in'.hardcoded;
    } else {
      return 'Need an account? Register'.hardcoded;
    }
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    if (formType == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInFormType.signIn;
    } else {
      return EmailPasswordSignInFormType.register;
    }
  }

  String get errorAlertTitle {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Registration failed'.hardcoded;
    } else {
      return 'Sign in failed'.hardcoded;
    }
  }

  String get title {
    if (formType == EmailPasswordSignInFormType.register) {
      return 'Register'.hardcoded;
    } else {
      return 'Sign in'.hardcoded;
    }
  }

  bool canSubmitEmail(String email) => emailSubmitValidator.isValid(email);

  bool canSubmitPassword(String password) {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  String? emailErrorText(String email) {
    final bool showErrorText = !canSubmitEmail(email);
    final String errorText = email.isEmpty ? 'Email can\'t be empty'.hardcoded : 'Invalid email'.hardcoded;
    return showErrorText ? errorText : null;
  }

  String? passwordErrorText(String password) {
    final bool showErrorText = !canSubmitPassword(password);
    final String errorText =
        password.isEmpty ? 'Password can\'t be empty'.hardcoded : 'Password is too short'.hardcoded;
    return showErrorText ? errorText : null;
  }
}

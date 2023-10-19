import 'package:ecommerce_app/src/common_widgets/custom_text_button.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_scrollable_card.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_screen_controller.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/string_validators.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmailPasswordSignInScreen extends StatelessWidget {
  const EmailPasswordSignInScreen({
    required this.formType,
    super.key,
  });

  final EmailPasswordSignInFormType formType;

  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('Sign In'.hardcoded)),
        body: EmailPasswordSignInContents(
          formType: formType,
        ),
      );
}

class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  const EmailPasswordSignInContents({
    required this.formType,
    this.onSignedIn,
    super.key,
  });

  final VoidCallback? onSignedIn;
  final EmailPasswordSignInFormType formType;

  @override
  ConsumerState<EmailPasswordSignInContents> createState() => _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState extends ConsumerState<EmailPasswordSignInContents> {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  bool _submitted = false;

  @override
  void dispose() {
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(EmailPasswordSignInState state) async {
    setState(() => _submitted = true);

    if (_formKey.currentState!.validate()) {
      final controller = ref.read(emailPasswordSignInScreenControllerProvider(widget.formType).notifier);
      final success = await controller.submit(email, password);

      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  void _emailEditingComplete(EmailPasswordSignInState state) {
    if (state.canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete(EmailPasswordSignInState state) {
    if (!state.canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit(state);
  }

  void _updateFormType(EmailPasswordSignInFormType formType) {
    final controller = ref.read(emailPasswordSignInScreenControllerProvider(widget.formType).notifier);
    controller.updateFormType(formType);
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      emailPasswordSignInScreenControllerProvider(widget.formType).select((state) => state.value),
      (_, current) => current.showAlertDialogOnError(context),
    );
    final state = ref.watch(emailPasswordSignInScreenControllerProvider(widget.formType));

    return ResponsiveScrollableCard(
      child: FocusScope(
        node: _node,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              gapH8,
              TextFormField(
                key: EmailPasswordSignInScreen.emailKey,
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email'.hardcoded,
                  hintText: 'test@test.com'.hardcoded,
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => !_submitted ? null : state.emailErrorText(email ?? ''),
                autocorrect: false,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _emailEditingComplete(state),
                inputFormatters: <TextInputFormatter>[
                  ValidatorInputFormatter(editingValidator: EmailEditingRegexValidator()),
                ],
              ),
              gapH8,
              TextFormField(
                key: EmailPasswordSignInScreen.passwordKey,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: state.passwordLabelText,
                  enabled: !state.isLoading,
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (password) => !_submitted ? null : state.passwordErrorText(password ?? ''),
                obscureText: true,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                keyboardAppearance: Brightness.light,
                onEditingComplete: () => _passwordEditingComplete(state),
              ),
              gapH8,
              PrimaryButton(
                text: state.primaryButtonText,
                isLoading: state.isLoading,
                onPressed: state.isLoading ? null : () => _submit(state),
              ),
              gapH8,
              CustomTextButton(
                text: state.secondaryButtonText,
                onPressed: state.isLoading ? null : () => _updateFormType(state.secondaryActionFormType),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

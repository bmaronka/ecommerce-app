import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_page.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CheckoutSubRoute { register, payment }

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  late final PageController _controller;

  var _subRoute = CheckoutSubRoute.register;

  @override
  void initState() {
    final user = ref.read(authRepositoryProvider).currentUser;

    if (user != null) {
      setState(() => _subRoute = CheckoutSubRoute.payment);
    }
    _controller = PageController(initialPage: _subRoute.index);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSignedIn() {
    setState(() => _subRoute = CheckoutSubRoute.payment);
    _controller.animateToPage(
      _subRoute.index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _subRoute == CheckoutSubRoute.register ? 'Register'.hardcoded : 'Payment'.hardcoded;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          EmailPasswordSignInContents(
            formType: EmailPasswordSignInFormType.register,
            onSignedIn: _onSignedIn,
          ),
          const PaymentPage(),
        ],
      ),
    );
  }
}

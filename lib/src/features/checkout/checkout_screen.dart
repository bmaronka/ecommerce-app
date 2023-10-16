import 'package:ecommerce_app/src/features/checkout/payment/payment_page.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/sign_in/email_password_sign_in_state.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

enum CheckoutSubRoute { register, payment }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _controller = PageController();

  var _subRoute = CheckoutSubRoute.register;

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

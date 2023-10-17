import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({super.key});

  Future<void> _pay(BuildContext context) async {
    // TODO: Implement
    await showNotImplementedAlertDialog(context: context);
  }

  // TODO: error handling
  // TODO: loading state
  @override
  Widget build(BuildContext context) => PrimaryButton(
        text: 'Pay'.hardcoded,
        isLoading: false,
        onPressed: () => _pay(context),
      );
}

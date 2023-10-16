import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class ActionTextButton extends StatelessWidget {
  const ActionTextButton({
    required this.text,
    this.onPressed,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: TextButton(
          child: Text(text, style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white)),
          onPressed: onPressed,
        ),
      );
}

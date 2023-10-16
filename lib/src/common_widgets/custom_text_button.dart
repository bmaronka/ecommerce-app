import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    required this.text,
    this.style,
    this.onPressed,
  });

  final String text;
  final TextStyle? style;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: Sizes.p48,
        child: TextButton(
          child: Text(
            text,
            style: style,
            textAlign: TextAlign.center,
          ),
          onPressed: onPressed,
        ),
      );
}

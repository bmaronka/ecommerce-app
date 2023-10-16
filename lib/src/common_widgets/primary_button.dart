import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({required this.text, this.isLoading = false, this.onPressed, super.key});

  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: Sizes.p48,
        child: ElevatedButton(
          onPressed: onPressed,
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
        ),
      );
}

import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class DecoratedBoxWithShadow extends StatelessWidget {
  const DecoratedBoxWithShadow({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0),
              blurRadius: 5.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: child,
        ),
      );
}

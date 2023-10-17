import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/presentation/cart_total/cart_total_text.dart';
import 'package:flutter/material.dart';

class CartTotalWithCTA extends StatelessWidget {
  const CartTotalWithCTA({
    required this.ctaBuilder,
    super.key,
  });

  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CartTotalText(),
          gapH8,
          ctaBuilder(context),
          gapH8,
        ],
      );
}

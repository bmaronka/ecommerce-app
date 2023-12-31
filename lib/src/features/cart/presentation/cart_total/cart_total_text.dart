import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartTotalText extends ConsumerWidget {
  const CartTotalText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartTotalValue = ref.watch(cartTotalProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: Sizes.p48),
      child: AsyncValueWidget(
        value: cartTotalValue,
        data: (cartTotal) {
          final totalFormatted = ref.watch(currencyFormatterProvider).format(cartTotal);
          return Text(
            'Total: $totalFormatted',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          );
        },
      ),
    );
  }
}

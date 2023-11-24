import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_items_builder.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends ConsumerWidget {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<double>>(
      cartTotalProvider,
      (_, state) {
        state.whenOrNull(
          data: (cartTotal) {
            if (state == 0.0) {
              context.goNamed(AppRoute.orders.name);
            }
          },
        );
      },
    );
    final cartValue = ref.watch(cartProvider);

    return AsyncValueWidget(
      value: cartValue,
      data: (cart) => ShoppingCartItemsBuilder(
        items: cart.toItemsList(),
        itemBuilder: (_, item, index) => ShoppingCartItem(
          item: item,
          itemIndex: index,
          isEditable: false,
        ),
        ctaBuilder: (_) => const PaymentButton(),
      ),
    );
  }
}

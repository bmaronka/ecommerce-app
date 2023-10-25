import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShoppingCartIcon extends ConsumerWidget {
  const ShoppingCartIcon({super.key});

  static const shoppingCartIconKey = Key('shopping-cart');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItemsCount = ref.watch(cartItemsCountProvider);

    return Stack(
      children: [
        Center(
          child: IconButton(
            key: shoppingCartIconKey,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.pushNamed(AppRoute.cart.name),
          ),
        ),
        if (cartItemsCount > 0)
          Positioned(
            top: Sizes.p4,
            right: Sizes.p4,
            child: ShoppingCartIconBadge(itemsCount: cartItemsCount),
          ),
      ],
    );
  }
}

class ShoppingCartIconBadge extends StatelessWidget {
  const ShoppingCartIconBadge({
    required this.itemsCount,
    super.key,
  });

  final int itemsCount;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: Sizes.p16,
        height: Sizes.p16,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$itemsCount',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
          ),
        ),
      );
}

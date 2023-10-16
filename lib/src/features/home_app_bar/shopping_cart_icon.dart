import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/shopping_cart/shopping_cart_screen.dart';
import 'package:flutter/material.dart';

class ShoppingCartIcon extends StatelessWidget {
  const ShoppingCartIcon({super.key});

  static const shoppingCartIconKey = Key('shopping-cart');

  // TODO: Read from data source
  @override
  Widget build(BuildContext context) {
    const cartItemsCount = 3;

    return Stack(
      children: [
        Center(
          child: IconButton(
            key: shoppingCartIconKey,
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (_) => const ShoppingCartScreen(),
              ),
            ),
          ),
        ),
        if (cartItemsCount > 0)
          const Positioned(
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

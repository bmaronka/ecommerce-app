import 'package:ecommerce_app/src/common_widgets/cart_total_with_cta.dart';
import 'package:ecommerce_app/src/common_widgets/decorated_box_with_shadow.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/constants/breakpoints.dart';
import 'package:ecommerce_app/src/features/not_found/empty_placeholder_widget.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/models/item.dart';
import 'package:flutter/material.dart';

class ShoppingCartItemsBuilder extends StatelessWidget {
  const ShoppingCartItemsBuilder({
    required this.items,
    required this.itemBuilder,
    required this.ctaBuilder,
    super.key,
  });

  final List<Item> items;
  final Widget Function(BuildContext, Item, int) itemBuilder;
  final WidgetBuilder ctaBuilder;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyPlaceholderWidget(
        message: 'Your shopping cart is empty'.hardcoded,
      );
    }

    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= Breakpoint.tablet) {
      return ResponsiveCenter(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return itemBuilder(context, item, index);
                },
                itemCount: items.length,
              ),
            ),
            gapW16,
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(Sizes.p16),
              itemBuilder: (context, index) {
                final item = items[index];
                return itemBuilder(context, item, index);
              },
              itemCount: items.length,
            ),
          ),
          DecoratedBoxWithShadow(
            child: CartTotalWithCTA(ctaBuilder: ctaBuilder),
          ),
        ],
      );
    }
  }
}

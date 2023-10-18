import 'dart:math';

import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app/src/common_widgets/loading_image_placeholder.dart';
import 'package:ecommerce_app/src/common_widgets/loading_text_placeholder.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:ecommerce_app/src/common_widgets/shimmer_effect_widget.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ShoppingCartItem extends ConsumerWidget {
  const ShoppingCartItem({
    required this.item,
    required this.itemIndex,
    this.isEditable = true,
    super.key,
  });

  final Item item;
  final int itemIndex;
  final bool isEditable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productStreamProvider(item.productId));

    return AsyncValueWidget(
      value: productValue,
      data: (product) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p16),
            child: ShoppingCartItemContents(
              product: product!,
              item: item,
              itemIndex: itemIndex,
              isEditable: isEditable,
            ),
          ),
        ),
      ),
      loading: LoadingShoppingCartItem.new,
    );
  }
}

class ShoppingCartItemContents extends StatelessWidget {
  const ShoppingCartItemContents({
    required this.product,
    required this.item,
    required this.itemIndex,
    required this.isEditable,
    super.key,
  });

  final Product product;
  final Item item;
  final int itemIndex;
  final bool isEditable;

  static Key deleteKey(int index) => Key('delete-$index');

  // TODO: error handling
  // TODO: Inject formatter
  @override
  Widget build(BuildContext context) => ResponsiveTwoColumnLayout(
        startFlex: 1,
        endFlex: 2,
        breakpoint: 320,
        startContent: CustomImage(imageUrl: product.imageUrl),
        spacing: Sizes.p24,
        endContent: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(product.title, style: Theme.of(context).textTheme.headlineSmall),
            gapH24,
            Text(
              NumberFormat.simpleCurrency().format(product.price),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            gapH24,
            isEditable
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ItemQuantitySelector(
                        quantity: item.quantity,
                        maxQuantity: min(product.availableQuantity, 10),
                        itemIndex: itemIndex,
                        // TODO: Implement onChanged
                        onChanged: (value) {
                          showNotImplementedAlertDialog(context: context);
                        },
                      ),
                      IconButton(
                        key: deleteKey(itemIndex),
                        icon: Icon(Icons.delete, color: Colors.red[700]),
                        // TODO: Implement onPressed
                        onPressed: () {
                          showNotImplementedAlertDialog(context: context);
                        },
                      ),
                      const Spacer(),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
                    child: Text(
                      'Quantity: ${item.quantity}'.hardcoded,
                    ),
                  ),
          ],
        ),
      );
}

class LoadingShoppingCartItem extends StatelessWidget {
  const LoadingShoppingCartItem({super.key});

  @override
  Widget build(BuildContext context) => ShimmerEffectWidget(
        child: ResponsiveTwoColumnLayout(
          startFlex: 1,
          endFlex: 2,
          breakpoint: 320,
          startContent: LoadingImagePlaceholder(),
          spacing: Sizes.p24,
          endContent: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LoadingTextPlaceholder(),
              gapH24,
              LoadingTextPlaceholder(),
              gapH24,
              LoadingTextPlaceholder(),
            ],
          ),
        ),
      );
}

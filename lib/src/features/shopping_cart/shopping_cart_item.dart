import 'dart:math';

import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/common_widgets/item_quantity_selector.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/models/item.dart';
import 'package:ecommerce_app/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShoppingCartItem extends StatelessWidget {
  const ShoppingCartItem({
    required this.item,
    required this.itemIndex,
    this.isEditable = true,
    super.key,
  });

  final Item item;
  final int itemIndex;
  final bool isEditable;

  // TODO: Read from data source
  @override
  Widget build(BuildContext context) {
    final product = kTestProducts.firstWhere((product) => product.id == item.productId);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.p16),
          child: ShoppingCartItemContents(
            product: product,
            item: item,
            itemIndex: itemIndex,
            isEditable: isEditable,
          ),
        ),
      ),
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
  Widget build(BuildContext context) {
    final priceFormatted = NumberFormat.simpleCurrency().format(product.price);

    return ResponsiveTwoColumnLayout(
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
          Text(priceFormatted, style: Theme.of(context).textTheme.headlineSmall),
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
}

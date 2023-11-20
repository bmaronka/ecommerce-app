import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/common_widgets/loading_image_placeholder.dart';
import 'package:ecommerce_app/src/common_widgets/loading_text_placeholder.dart';
import 'package:ecommerce_app/src/common_widgets/shimmer_effect_widget.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderItemListTile extends ConsumerWidget {
  const OrderItemListTile({required this.item, super.key});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productStreamProvider(item.productId));

    return AsyncValueWidget(
      value: productValue,
      data: (product) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: CustomImage(imageUrl: product!.imageUrl),
            ),
            gapW8,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title),
                  gapH12,
                  Text(
                    'Quantity: ${item.quantity}'.hardcoded,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      loading: LoadingOrderItem.new,
    );
  }
}

class LoadingOrderItem extends StatelessWidget {
  const LoadingOrderItem({super.key});

  @override
  Widget build(BuildContext context) => ShimmerEffectWidget(
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: LoadingImagePlaceholder(),
            ),
            gapW8,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingTextPlaceholder(),
                  gapH12,
                  LoadingTextPlaceholder(),
                ],
              ),
            ),
          ],
        ),
      );
}

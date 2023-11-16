import 'dart:math';

import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/constants/breakpoints.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/product_card.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SliverProductsGrid extends ConsumerWidget {
  const SliverProductsGrid({this.onPressed, super.key});

  final void Function(BuildContext, ProductID)? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: restore search functionality
    //final productsListValue = ref.watch(productsSearchResultsProvider);
    final productsListValue = ref.watch(productsListStreamProvider);
    return AsyncValueSliverWidget<List<Product>>(
      value: productsListValue,
      data: (products) => SliverProductsAlignedGrid(
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onPressed: () => onPressed?.call(context, product.id),
          );
        },
      ),
    );
  }
}

class SliverProductsAlignedGrid extends StatelessWidget {
  const SliverProductsAlignedGrid({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
  });

  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    if (itemCount == 0) {
      return SliverToBoxAdapter(
        child: Center(
          child: Text(
            'No products found'.hardcoded,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      );
    }

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        final maxWidth = min(width, Breakpoint.desktop);
        final crossAxisCount = max(1, maxWidth ~/ 250);
        final padding = width > Breakpoint.desktop + Sizes.p32 ? (width - Breakpoint.desktop) / 2 : Sizes.p16;

        return SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: Sizes.p16,
          ),
          sliver: SliverAlignedGrid.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: Sizes.p24,
            crossAxisSpacing: Sizes.p24,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
          ),
        );
      },
    );
  }
}

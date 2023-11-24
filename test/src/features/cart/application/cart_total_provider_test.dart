import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'loading cart',
    () async {
      final container = makeProviderContainer(
        cart: Stream.empty(),
        products: kTestProducts,
      );

      final total = container.read(cartTotalProvider);

      expect(total, const AsyncLoading<double>());
    },
  );

  test(
    'empty cart',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart()),
        products: kTestProducts,
      );

      await container.read(cartProvider.future);
      final total = await container.read(cartTotalProvider.future);

      expect(total, 0);
    },
  );

  test(
    'one product with quantity = 1',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 1})),
        products: kTestProducts,
      );

      await container.read(cartProvider.future);
      final total = await container.read(cartTotalProvider.future);

      expect(total, 15);
    },
  );

  test(
    'one product with quantity = 5',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 5})),
        products: kTestProducts,
      );

      await container.read(cartProvider.future);
      final total = await container.read(cartTotalProvider.future);

      expect(total, 75);
    },
  );

  test(
    'two products',
    () async {
      const cart = Cart({
        '1': 3,
        '2': 2,
      });
      final container = makeProviderContainer(
        cart: Stream.value(cart),
        products: kTestProducts,
      );

      await container.read(cartProvider.future);
      final total = await container.read(cartTotalProvider.future);

      expect(total, 71);
    },
  );

  test(
    'product not found',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'100': 1})),
        products: kTestProducts,
        notFoundProducts: ['100'],
      );

      await container.read(cartProvider.future);
      final total = await container.read(cartTotalProvider.future);

      expect(total, 0);
    },
  );
}

ProviderContainer makeProviderContainer({
  required Stream<Cart> cart,
  required List<Product> products,
  List<ProductID> notFoundProducts = const [],
}) {
  final container = ProviderContainer(
    overrides: [
      cartProvider.overrideWith((ref) => cart),
      for (final p in products) productStreamProvider(p.id).overrideWith((ref) => Stream.value(p)),
      for (final pid in notFoundProducts) productStreamProvider(pid).overrideWith((ref) => Stream.value(null)),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

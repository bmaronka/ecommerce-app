import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'loading cart',
    () async {
      final container = makeProviderContainer(
        cart: Stream.empty(),
        products: Stream.value(kTestProducts),
      );

      await container.read(cartProvider.future);
      await container.read(productsListStreamProvider.future);
      final total = container.read(cartTotalProvider);

      expect(total, 0);
    },
  );

  test(
    'empty cart',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart()),
        products: Stream.value(kTestProducts),
      );

      await container.read(cartProvider.future);
      await container.read(productsListStreamProvider.future);
      final total = container.read(cartTotalProvider);

      expect(total, 0);
    },
  );

  test(
    'one product with quantity = 1',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 1})),
        products: Stream.value(kTestProducts),
      );

      await container.read(cartProvider.future);
      await container.read(productsListStreamProvider.future);
      final total = container.read(cartTotalProvider);

      expect(total, 15);
    },
  );

  test(
    'one product with quantity = 5',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'1': 5})),
        products: Stream.value(kTestProducts),
      );

      await container.read(cartProvider.future);
      await container.read(productsListStreamProvider.future);
      final total = container.read(cartTotalProvider);

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
        products: Stream.value(kTestProducts),
      );

      await container.read(cartProvider.future);
      await container.read(productsListStreamProvider.future);
      final total = container.read(cartTotalProvider);

      expect(total, 71);
    },
  );

  test(
    'product not found',
    () async {
      final container = makeProviderContainer(
        cart: Stream.value(const Cart({'100': 1})),
        products: Stream.value(kTestProducts),
      );

      await container.read(cartProvider.future);
      await container.read(productsListStreamProvider.future);
      final total = container.read(cartTotalProvider);

      expect(total, 0);
    },
  );
}

ProviderContainer makeProviderContainer({
  required Stream<Cart> cart,
  required Stream<List<Product>> products,
}) {
  final container = ProviderContainer(
    overrides: [
      cartProvider.overrideWith((ref) => cart),
      productsListStreamProvider.overrideWith((ref) => products),
    ],
  );

  addTearDown(container.dispose);
  return container;
}

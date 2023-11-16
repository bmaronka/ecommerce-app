import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeProductsRepository repository;

  setUp(() => repository = FakeProductsRepository(addDelay: false));

  test(
    'getProductList returns global list',
    () {
      final products = repository.getProductList();

      expect(products, kTestProducts);
    },
  );

  test(
    'getProduct(1) retrurns first item',
    () {
      final product = repository.getProduct('1');

      expect(product, kTestProducts[0]);
    },
  );

  test(
    'getProduct(100) retrurns null',
    () {
      final product = repository.getProduct('100');

      expect(product, null);
    },
  );

  test(
    'fetchProductList returns global list',
    () async {
      final products = await repository.fetchProductsList();

      expect(products, kTestProducts);
    },
  );

  test(
    'watchProductList emits global list',
    () async {
      final productsStream = repository.watchProductsList();

      expect(productsStream, emits(kTestProducts));
    },
  );

  test(
    'watchProduct(1) emits first item',
    () {
      final productStream = repository.watchProduct('1');

      expect(productStream, emits(kTestProducts[0]));
    },
  );

  test(
    'watchProduct(100) emits null',
    () {
      final productStream = repository.watchProduct('100');

      expect(productStream, emits(null));
    },
  );
}

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeProductsRepository repository;

  final testProduct = Product(
    id: '15',
    imageUrl: 'testUrl.com',
    title: '',
    description: '',
    price: 0.0,
    availableQuantity: 0,
  );

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
    () {
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

  test(
    'search existing products',
    () async {
      final foundProducts = await repository.searchProducts('piggy');

      expect(foundProducts.length, 3);
    },
  );

  test(
    'search non-existing products',
    () async {
      final foundProducts = await repository.searchProducts('lala');

      expect(foundProducts.length, 0);
    },
  );

  test(
    'create product',
    () async {
      expect(repository.getProductList().length, 14);

      await repository.createProduct(testProduct.id, testProduct.imageUrl);

      expect(repository.getProductList().length, 15);
    },
  );

  test(
    'update product',
    () async {
      await repository.createProduct(testProduct.id, testProduct.imageUrl);
      expect(repository.getProduct(testProduct.id)?.avgRating, 0.0);
      expect(repository.getProduct(testProduct.id)?.availableQuantity, 0);

      await repository.updateProduct(testProduct.copyWith(avgRating: 3.0, availableQuantity: 5));
      expect(repository.getProduct(testProduct.id)?.avgRating, 3.0);
      expect(repository.getProduct(testProduct.id)?.availableQuantity, 5);
    },
  );

  test(
    'delete product',
    () async {
      expect(repository.getProductList().length, 14);

      await repository.deleteProduct('13');

      expect(repository.getProductList().length, 13);
    },
  );

  test(
    'fetchProduct(1) retrurns first item',
    () async {
      final product = await repository.fetchProduct('1');

      expect(product, kTestProducts[0]);
    },
  );
}

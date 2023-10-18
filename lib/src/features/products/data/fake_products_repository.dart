import 'package:collection/collection.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

class FakeProductsRepository {
  const FakeProductsRepository._();
  static const FakeProductsRepository instance = FakeProductsRepository._();

  final List<Product> _products = kTestProducts;

  List<Product> getProductList() => _products;

  Product? getProduct(String id) => _products.firstWhereOrNull((product) => product.id == id);

  Future<List<Product>> fetchProductList() => Future.value(_products);

  Stream<List<Product>> watchProductList() => Stream.value(_products);

  Stream<Product?> watchProduct(String id) =>
      watchProductList().map((products) => products.firstWhereOrNull((product) => product.id == id));
}

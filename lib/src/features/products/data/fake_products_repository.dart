import 'package:collection/collection.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeProductsRepository implements ProductsRepository {
  FakeProductsRepository({
    this.addDelay = true,
  });

  final bool addDelay;
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductList() => _products.value;

  Product? getProduct(String id) => _getProduct(_products.value, id);

  @override
  Future<List<Product>> fetchProductsList() async => Future.value(_products.value);

  @override
  Stream<List<Product>> watchProductsList() => _products.stream;

  @override
  Stream<Product?> watchProduct(String id) => watchProductsList().map((products) => _getProduct(products, id));

  Future<void> setProduct(Product product) async {
    await delay(addDelay);

    final products = _products.value;
    final index = products.indexWhere((p) => p.id == product.id);

    if (index == -1) {
      products.add(product);
    } else {
      products[index] = product;
    }

    _products.value = products;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    assert(
      _products.value.length <= 100,
      'Client-side search should only be performed if the number of products is small',
    );

    final productList = await fetchProductsList();
    return productList.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  static Product? _getProduct(List<Product> products, String id) =>
      products.firstWhereOrNull((product) => product.id == id);

  @override
  Future<void> createProduct(ProductID productId, String imageUrl) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<void> updateProduct(Product product) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(ProductID id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Product?> fetchProduct(ProductID id) {
    // TODO: implement fetchProduct
    throw UnimplementedError();
  }
}

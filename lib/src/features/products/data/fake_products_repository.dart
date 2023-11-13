import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  FakeProductsRepository({
    this.addDelay = true,
  });

  final bool addDelay;
  final _products = InMemoryStore<List<Product>>(List.from(kTestProducts));

  List<Product> getProductList() => _products.value;

  Product? getProduct(String id) => _getProduct(_products.value, id);

  Future<List<Product>> fetchProductList() async => Future.value(_products.value);

  Stream<List<Product>> watchProductList() => _products.stream;

  Stream<Product?> watchProduct(String id) => watchProductList().map((products) => _getProduct(products, id));

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

  Future<List<Product>> searchProducts(String query) async {
    assert(
      _products.value.length <= 100,
      'Client-side search should only be performed if the number of products is small',
    );

    final productList = await fetchProductList();
    return productList.where((product) => product.title.toLowerCase().contains(query.toLowerCase())).toList();
  }

  static Product? _getProduct(List<Product> products, String id) =>
      products.firstWhereOrNull((product) => product.id == id);
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) => FakeProductsRepository());

final productsListStreamProvider = StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductList();
});

final productsListFutureProvider = FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductList();
});

final productStreamProvider = StreamProvider.autoDispose.family<Product?, String>((ref, id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
});

final productListSearchProvider = FutureProvider.autoDispose.family<List<Product>, String>((ref, query) async {
  final link = ref.keepAlive();
  Timer(
    const Duration(seconds: 5),
    link.close,
  );
  return ref.watch(productsRepositoryProvider).searchProducts(query);
});

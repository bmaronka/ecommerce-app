import 'dart:async';

import 'package:collection/collection.dart';
import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeProductsRepository {
  const FakeProductsRepository({
    this.addDelay = true,
  });

  final bool addDelay;
  final List<Product> _products = kTestProducts;

  List<Product> getProductList() => _products;

  Product? getProduct(String id) => _products.firstWhereOrNull((product) => product.id == id);

  Future<List<Product>> fetchProductList() async {
    await delay(addDelay);
    return _products;
  }

  Stream<List<Product>> watchProductList() async* {
    await delay(addDelay);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) =>
      watchProductList().map((products) => products.firstWhereOrNull((product) => product.id == id));
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) => const FakeProductsRepository());

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

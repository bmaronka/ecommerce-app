import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_repository.g.dart';

class ProductsRepository {
  const ProductsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<Product>> fetchProductsList() => Future.value([]);

  Stream<List<Product>> watchProductsList() => Stream.value([]);

  Stream<Product?> watchProduct(ProductID id) => Stream.value(null);

  Future<List<Product>> searchProducts(String query) => Future.value([]);
}

@Riverpod(keepAlive: true)
ProductsRepository productsRepository(ProductsRepositoryRef ref) => ProductsRepository(FirebaseFirestore.instance);

@riverpod
Stream<List<Product>> productsListStream(ProductsListStreamRef ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
}

@riverpod
Future<List<Product>> productsListFuture(ProductsListFutureRef ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductsList();
}

@riverpod
Stream<Product?> product(ProductRef ref, ProductID id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
}

@riverpod
Future<List<Product>> productsListSearch(
  ProductsListSearchRef ref,
  String query,
) async {
  final link = ref.keepAlive();
  Timer? timer;
  ref.onDispose(() {
    timer?.cancel();
  });
  ref.onCancel(() {
    timer = Timer(const Duration(seconds: 30), link.close);
  });
  ref.onResume(() {
    timer?.cancel();
  });
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.searchProducts(query);
}

import 'dart:async';

import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_repository.g.dart';

// TODO: Implement with Firebase
abstract class ProductsRepository {
  Future<List<Product>> fetchProductsList();

  Stream<List<Product>> watchProductsList();

  Stream<Product?> watchProduct(ProductID id);

  Future<List<Product>> searchProducts(String query);
}

@Riverpod(keepAlive: true)
ProductsRepository productsRepository(ProductsRepositoryRef ref) {
  // TODO: create and return repository
  throw UnimplementedError();
}

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

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'products_repository.g.dart';

class ProductsRepository {
  const ProductsRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static String productsPath() => 'products';
  static String productPath(ProductID id) => 'products/$id';

  Future<List<Product>> fetchProductsList() =>
      _productsRef().get().then((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());

  Stream<List<Product>> watchProductsList() =>
      _productsRef().snapshots().map((snapshot) => snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());

  Future<Product?> fetchProduct(ProductID id) => _productRef(id).get().then((snapshot) => snapshot.data());

  Stream<Product?> watchProduct(ProductID id) => _productRef(id).snapshots().map((snapshot) => snapshot.data());

  //TODO
  Future<List<Product>> searchProducts(String query) async {
    final productsList = await fetchProductsList();
    return productsList
        .where(
          (product) => product.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  Future<void> createProduct(ProductID id, String imageUrl) => _firestore.doc('products/$id').set(
        {
          'id': id,
          'imageUrl': imageUrl,
        },
        SetOptions(merge: true),
      );

  Future<void> updateProduct(Product product) => _productRef(product.id).set(product);

  Future<void> deleteProduct(ProductID id) => _productRef(id).delete();

  DocumentReference<Product> _productRef(ProductID id) => _firestore.doc(productPath(id)).withConverter(
        fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
        toFirestore: (Product product, options) => product.toMap(),
      );

  Query<Product> _productsRef() => _firestore
      .collection(productsPath())
      .withConverter(
        fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
        toFirestore: (Product product, options) => product.toMap(),
      )
      .orderBy('id');
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
Stream<Product?> productStream(ProductStreamRef ref, ProductID id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProduct(id);
}

@riverpod
Future<Product?> productFuture(ProductFutureRef ref, ProductID id) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProduct(id);
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

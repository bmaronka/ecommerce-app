import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

//Created to learn how to work with fake_cloud_firestore package
void main() {
  late FirebaseFirestore store;

  late ProductsRepository productsRepository;

  setUp(() {
    store = FakeFirebaseFirestore();

    productsRepository = ProductsRepository(store);
  });

  CollectionReference<Product> _productsRef() => store.collection('products').withConverter(
        fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
        toFirestore: (Product product, options) => product.toMap(),
      );

  DocumentReference<Product> _productRef(ProductID id) => store.doc('products/$id').withConverter(
        fromFirestore: (doc, _) => Product.fromMap(doc.data()!),
        toFirestore: (Product product, options) => product.toMap(),
      );

  final testProduct1 = Product(
    id: '1',
    imageUrl: 'imageUrl1.com',
    title: 'title1',
    description: 'description1',
    price: 5.0,
    availableQuantity: 5,
  );
  final updatedTestProduct1 = Product(
    id: '1',
    imageUrl: 'imageUrl1.com',
    title: 'titlee1',
    description: 'description1',
    price: 5.0,
    availableQuantity: 5,
  );
  final testProduct2 = Product(
    id: '2',
    imageUrl: 'imageUrl2.com',
    title: 'title2',
    description: 'description2',
    price: 5.0,
    availableQuantity: 5,
  );

  test(
    'fetch products',
    () async {
      await _productsRef().add(testProduct1);
      await _productsRef().add(testProduct2);

      final products = await productsRepository.fetchProductsList();

      expect(products, [testProduct1, testProduct2]);
    },
  );

  test(
    'fetch product',
    () async {
      await _productRef(testProduct1.id).set(testProduct1);

      final product = await productsRepository.fetchProduct(testProduct1.id);

      expect(product, testProduct1);
    },
  );

  test(
    'watch products',
    () async {
      await _productsRef().add(testProduct1);

      expect(
        productsRepository.watchProductsList(),
        emitsInOrder([
          [testProduct1],
          [testProduct1, testProduct2],
        ]),
      );

      await _productsRef().add(testProduct2);
    },
  );

  test(
    'search product',
    () async {
      await _productsRef().add(testProduct1);
      await _productsRef().add(testProduct2);

      final foundProduct = await productsRepository.searchProducts('2');

      expect(foundProduct, [testProduct2]);
    },
  );

  test(
    'create product',
    () async {
      await productsRepository.createProduct('3', 'imageUrl3.com');

      final product = await productsRepository.fetchProduct('3');

      expect(product?.id, '3');
      expect(product?.imageUrl, 'imageUrl3.com');
    },
  );

  test(
    'update product',
    () async {
      await _productRef(testProduct1.id).set(testProduct1);

      expect(
        productsRepository.watchProduct(testProduct1.id),
        emitsInOrder([
          testProduct1,
          updatedTestProduct1,
        ]),
      );

      await productsRepository.updateProduct(updatedTestProduct1);
    },
  );

  test(
    'delete product',
    () async {
      await _productRef(testProduct1.id).set(testProduct1);
      final products = await productsRepository.fetchProductsList();
      expect(products.length, 1);

      await productsRepository.deleteProduct(testProduct1.id);
      final productsAfterDelete = await productsRepository.fetchProductsList();
      expect(productsAfterDelete.length, 0);
    },
  );
}

import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_products_providers.g.dart';

@riverpod
ProductsRepository templateProductsRepository(TemplateProductsRepositoryRef ref) =>
    FakeProductsRepository(addDelay: false);

@riverpod
Stream<List<Product>> templateProductsList(TemplateProductsListRef ref) {
  return ref.watch(templateProductsRepositoryProvider).watchProductsList();
  // final templateProductsStream =
  //     ref.watch(templateProductsRepositoryProvider).watchProductsList();
  // final existingProductsStream =
  //     ref.watch(productsRepositoryProvider).watchProductsList();
  // return Rx.combineLatest2(templateProductsStream, existingProductsStream,
  //     (template, existing) {
  //   // return only the template products that have not been uploaded yet
  //   final existingProductIds = existing.map((product) => product.id).toList();
  //   return template
  //       .where((product) => !existingProductIds.contains(product.id))
  //       .toList();
  // });
}

@riverpod
Stream<Product?> templateProduct(TemplateProductRef ref, ProductID id) =>
    ref.watch(templateProductsRepositoryProvider).watchProduct(id);

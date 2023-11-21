import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/application/manage_product_service.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:ecommerce_app/src/utils/notifier_mounter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_product_edit_controller.g.dart';

@riverpod
class AdminProductEditController extends _$AdminProductEditController with NotifierMounted {
  @override
  FutureOr<void> build() {}

  Future<bool> updateProduct({
    required Product product,
    required String title,
    required String description,
    required String price,
    required String availableQuantity,
  }) async {
    final productsRepository = ref.read(productsRepositoryProvider);
    final updatedProduct = product.copyWith(
      title: title,
      description: description,
      price: double.parse(price),
      availableQuantity: int.parse(availableQuantity),
    );

    state = AsyncLoading();
    final value = await AsyncValue.guard(() => productsRepository.updateProduct(updatedProduct));
    final success = !value.hasError;

    if (mounted) {
      state = value;

      if (success) {
        ref.read(goRouterProvider).pop();
      }
    }

    return success;
  }

  Future<bool> deleteProduct(Product product) async {
    final manageProductService = ref.read(manageProductServiceProvider);

    state = AsyncLoading();
    final value = await AsyncValue.guard(() => manageProductService.deleteProduct(product));
    final success = !value.hasError;

    if (mounted) {
      state = value;

      if (success) {
        ref.read(goRouterProvider).pop();
      }
    }

    return success;
  }
}

import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/products_admin/application/manage_product_service.dart';
import 'package:ecommerce_app/src/router/router.dart';
import 'package:ecommerce_app/src/utils/notifier_mounter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_product_upload_controller.g.dart';

@riverpod
class AdminProductUploadController extends _$AdminProductUploadController with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
  }

  Future<void> upload(Product product) async {
    try {
      state = AsyncLoading();

      await ref.read(manageProductServiceProvider).uploadProduct(product);

      ref.read(goRouterProvider).goNamed(
        AppRoute.adminEditProduct.name,
        pathParameters: {
          'id': product.id,
        },
      );
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncError(error, stackTrace);
      }
    }
  }
}

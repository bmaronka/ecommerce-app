import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_to_cart_controller.g.dart';

@riverpod
class AddToCartController extends _$AddToCartController {
  @override
  FutureOr<int> build() => 1;

  void updateQuantity(int quantity) => state = AsyncData(quantity);

  Future<void> addItem(ProductID productId) async {
    final item = Item(
      productId: productId,
      quantity: state.value!,
    );

    state = const AsyncLoading<int>().copyWithPrevious(state);

    final value = await AsyncValue.guard(() => ref.read(cartServiceProvider).addItem(item));

    if (value.hasError) {
      state = AsyncError<int>(value.error!, StackTrace.current).copyWithPrevious(state);
    } else {
      state = const AsyncData(1);
    }
  }
}

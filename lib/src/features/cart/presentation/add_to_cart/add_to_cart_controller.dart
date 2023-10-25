import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToCartController extends StateNotifier<AsyncValue<int>> {
  AddToCartController({
    required this.cartService,
  }) : super(AsyncData(1));

  final CartService cartService;

  void updateQuantity(int quantity) => state = AsyncData(quantity);

  Future<void> addItem(ProductID productId) async {
    final item = Item(
      productId: productId,
      quantity: state.value!,
    );

    state = const AsyncLoading<int>().copyWithPrevious(state);

    final value = await AsyncValue.guard(() => cartService.addItem(item));

    if (value.hasError) {
      state = AsyncError<int>(value.error!, StackTrace.current).copyWithPrevious(state);
    } else {
      state = const AsyncData(1);
    }
  }
}

final addToCartControllerProvider = StateNotifierProvider.autoDispose<AddToCartController, AsyncValue<int>>(
  (ref) => AddToCartController(
    cartService: ref.watch(cartServiceProvider),
  ),
);

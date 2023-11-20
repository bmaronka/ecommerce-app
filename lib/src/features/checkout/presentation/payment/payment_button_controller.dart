import 'package:ecommerce_app/src/features/checkout/application/checkout_service.dart';
import 'package:ecommerce_app/src/utils/notifier_mounter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_button_controller.g.dart';

@riverpod
class PaymentButtonController extends _$PaymentButtonController with NotifierMounted {
  @override
  FutureOr<void> build() {
    ref.onDispose(setUnmounted);
  }

  Future<void> pay() async {
    state = AsyncLoading();
    final newState = await AsyncValue.guard(ref.read(checkoutServiceProvider).placeOrder);

    if (mounted) {
      state = newState;
    }
  }
}

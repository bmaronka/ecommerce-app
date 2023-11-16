import 'package:ecommerce_app/src/features/checkout/application/checkout_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_button_controller.g.dart';

@riverpod
class PaymentButtonController extends _$PaymentButtonController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;

  @override
  FutureOr<void> build() {
    ref.onDispose(() => current = Object());
  }

  Future<void> pay() async {
    state = AsyncLoading();
    final newState = await AsyncValue.guard(ref.read(checkoutServiceProvider).placeOrder);

    if (mounted) {
      state = newState;
    }
  }
}

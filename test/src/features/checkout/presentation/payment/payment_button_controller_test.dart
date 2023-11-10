import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late FakeCheckoutService fakeCheckoutService;
  late PaymentButtonController paymentButtonController;

  final exception = Exception('Connection failure');

  setUp(() {
    fakeCheckoutService = MockFakeCheckoutService();
    paymentButtonController = PaymentButtonController(
      checkoutService: fakeCheckoutService,
    );
  });

  test(
    'initial state is AsyncData(1)',
    () {
      expect(paymentButtonController.state, AsyncData<void>(null));
    },
  );

  group(
    'pay',
    () {
      test(
        'success',
        () async {
          when(fakeCheckoutService.placeOrder()).thenAnswer((_) => Future.value());

          expect(
            paymentButtonController.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              AsyncData<void>(null),
            ]),
          );

          await paymentButtonController.pay();

          verify(fakeCheckoutService.placeOrder()).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(fakeCheckoutService.placeOrder()).thenThrow(exception);

          expect(
            paymentButtonController.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              }),
            ]),
          );

          await paymentButtonController.pay();

          verify(fakeCheckoutService.placeOrder()).called(1);
        },
      );
    },
  );
}

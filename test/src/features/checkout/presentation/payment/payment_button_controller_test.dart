import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/payment/payment_button_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.dart';
import '../../../../mocks.mocks.dart';

void main() {
  late MockFakeCheckoutService checkoutService;

  setUp(() => checkoutService = MockFakeCheckoutService());

  final exception = Exception('Connection failure');

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        checkoutServiceProvider.overrideWithValue(checkoutService),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  group(
    'pay',
    () {
      test(
        'success',
        () async {
          when(checkoutService.placeOrder()).thenAnswer((_) => Future.value(null));
          final container = makeProviderContainer();
          final controller = container.read(paymentButtonControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            paymentButtonControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.pay();

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), data),
          ]);
          verifyNoMoreInteractions(listener);
          verify(checkoutService.placeOrder()).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(checkoutService.placeOrder()).thenThrow(exception);
          final container = makeProviderContainer();
          final controller = container.read(paymentButtonControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            paymentButtonControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.pay();

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(checkoutService.placeOrder()).called(1);
        },
      );
    },
  );
}

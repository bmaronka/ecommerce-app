import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.dart';
import '../../../../mocks.mocks.dart';

void main() {
  late CartService cartService;

  final exception = Exception('Connection failure');
  const testItem = Item(
    productId: '1',
    quantity: 2,
  );

  setUp(() => cartService = MockCartService());

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        cartServiceProvider.overrideWithValue(cartService),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  test(
    'initial state is AsyncData(1)',
    () {
      final container = makeProviderContainer();
      final listener = Listener();
      container.listen(
        addToCartControllerProvider,
        listener,
        fireImmediately: true,
      );

      verify(listener(null, AsyncData<int>(1)));
      verifyNoMoreInteractions(listener);
      verifyNever(cartService.addItem(testItem));
      verifyNever(cartService.setItem(testItem));
      verifyNever(cartService.removeItemById(testItem.productId));
    },
  );

  group(
    'addItem',
    () {
      test(
        'success',
        () async {
          final container = makeProviderContainer();
          final listener = Listener();
          container.listen(
            addToCartControllerProvider,
            listener,
            fireImmediately: true,
          );
          when(cartService.addItem(testItem)).thenAnswer((_) => Future.value());

          const initialData = AsyncData<int>(1);
          verify(listener(null, initialData));

          final controller = container.read(addToCartControllerProvider.notifier);
          controller.updateQuantity(2);
          verify(listener(initialData, const AsyncData<int>(2)));

          await controller.addItem(testItem.productId);
          verifyInOrder(
            [
              listener(
                const AsyncData<int>(2),
                const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(2)),
              ),
              listener(
                const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(2)),
                initialData,
              ),
            ],
          );
          verifyNoMoreInteractions(listener);
          verify(cartService.addItem(testItem)).called(1);
        },
      );

      test(
        'failure',
        () async {
          final container = makeProviderContainer();
          final listener = Listener();
          container.listen(
            addToCartControllerProvider,
            listener,
            fireImmediately: true,
          );
          when(cartService.addItem(testItem)).thenThrow(exception);

          const initialData = AsyncData<int>(1);
          verify(listener(null, initialData));

          final controller = container.read(addToCartControllerProvider.notifier);
          controller.updateQuantity(2);
          verify(listener(initialData, const AsyncData<int>(2)));

          await controller.addItem(testItem.productId);
          verifyInOrder(
            [
              listener(
                const AsyncData<int>(2),
                const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(2)),
              ),
              listener(
                const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(2)),
                argThat(isA<AsyncError>()),
              ),
            ],
          );
          verifyNoMoreInteractions(listener);
          verify(cartService.addItem(testItem)).called(1);
        },
      );
    },
  );
}

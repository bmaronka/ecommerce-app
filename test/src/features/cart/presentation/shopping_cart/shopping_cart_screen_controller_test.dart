import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.dart';
import '../../../../mocks.mocks.dart';

void main() {
  late MockCartService cartService;

  const productId = '1';
  final exception = Exception('Connection failure');

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

  group(
    'updateItemQuantity',
    () {
      test(
        'update quantity, success',
        () async {
          const item = Item(
            productId: productId,
            quantity: 3,
          );
          when(cartService.setItem(item)).thenAnswer((_) => Future.value(null));
          final container = makeProviderContainer();
          final controller = container.read(shoppingCartScreenControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            shoppingCartScreenControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.updateItemQuantity(productId, 3);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), data),
          ]);
          verifyNoMoreInteractions(listener);
          verify(cartService.setItem(item)).called(1);
        },
      );

      test(
        'update quantity, failure',
        () async {
          const item = Item(
            productId: productId,
            quantity: 3,
          );
          when(cartService.setItem(item)).thenThrow(exception);
          final container = makeProviderContainer();
          final controller = container.read(shoppingCartScreenControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            shoppingCartScreenControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.updateItemQuantity(productId, 3);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(cartService.setItem(item)).called(1);
        },
      );
    },
  );

  group(
    'removeItemById',
    () {
      test(
        'remove item, success',
        () async {
          when(cartService.removeItemById(productId)).thenAnswer((_) => Future.value(null));
          final container = makeProviderContainer();
          final controller = container.read(shoppingCartScreenControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            shoppingCartScreenControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.removeItemById(productId);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), data),
          ]);
          verifyNoMoreInteractions(listener);
          verify(cartService.removeItemById(productId)).called(1);
        },
      );

      test(
        'remove item, failure',
        () async {
          when(cartService.removeItemById(productId)).thenThrow(exception);
          final container = makeProviderContainer();
          final controller = container.read(shoppingCartScreenControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            shoppingCartScreenControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          await controller.removeItemById(productId);

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(cartService.removeItemById(productId)).called(1);
        },
      );
    },
  );
}

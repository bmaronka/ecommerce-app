import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late CartService cartService;

  late ShoppingCartScreenController shoppingCartScreenController;

  final exception = Exception('Connection failure');
  const testItem = Item(
    productId: '123',
    quantity: 3,
  );

  setUp(() {
    cartService = MockCartService();
    shoppingCartScreenController = ShoppingCartScreenController(cartService: cartService);
  });

  test(
    'initial state is AsyncData(1)',
    () {
      expect(shoppingCartScreenController.state, AsyncData<void>(null));
    },
  );

  group(
    'updateItemQuantity',
    () {
      test(
        'success',
        () async {
          when(cartService.setItem(testItem)).thenAnswer((_) => Future.value());

          expect(
            shoppingCartScreenController.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              AsyncData<void>(null),
            ]),
          );

          await shoppingCartScreenController.updateItemQuantity(testItem.productId, testItem.quantity);

          verify(cartService.setItem(testItem)).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(cartService.setItem(testItem)).thenThrow(exception);

          expect(
            shoppingCartScreenController.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              }),
            ]),
          );

          await shoppingCartScreenController.updateItemQuantity(testItem.productId, testItem.quantity);

          verify(cartService.setItem(testItem)).called(1);
        },
      );
    },
  );

  group(
    'removeItemById',
    () {
      test(
        'success',
        () async {
          when(cartService.removeItemById(testItem.productId)).thenAnswer((_) => Future.value());

          expect(
            shoppingCartScreenController.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              AsyncData<void>(null),
            ]),
          );

          await shoppingCartScreenController.removeItemById(testItem.productId);

          verify(cartService.removeItemById(testItem.productId)).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(cartService.removeItemById(testItem.productId)).thenThrow(exception);

          expect(
            shoppingCartScreenController.stream,
            emitsInOrder([
              const AsyncLoading<void>(),
              predicate<AsyncValue<void>>((value) {
                expect(value.hasError, true);
                return true;
              }),
            ]),
          );

          await shoppingCartScreenController.removeItemById(testItem.productId);

          verify(cartService.removeItemById(testItem.productId)).called(1);
        },
      );
    },
  );
}

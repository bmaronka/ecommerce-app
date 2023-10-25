import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/presentation/add_to_cart/add_to_cart_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late CartService cartService;

  late AddToCartController addToCartController;

  final exception = Exception('Connection failure');
  const testItem = Item(
    productId: '1',
    quantity: 1,
  );

  setUp(() {
    cartService = MockCartService();
    addToCartController = AddToCartController(cartService: cartService);
  });

  test(
    'initial state is AsyncData(1)',
    () {
      expect(addToCartController.state, AsyncData<int>(1));
    },
  );

  test(
    '''
      Given state is AsyncData(1)
      When updateQuantity with value 2
      Then state is AsyncData(2)
    ''',
    () {
      expect(addToCartController.state, AsyncData<int>(1));
      addToCartController.updateQuantity(2);
      expect(addToCartController.state, AsyncData<int>(2));
    },
  );

  group(
    'addItem',
    () {
      test(
        'success',
        () async {
          when(cartService.addItem(testItem)).thenAnswer((_) => Future.value());

          expect(
            addToCartController.stream,
            emitsInOrder([
              const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(1)),
              const AsyncData<int>(1),
            ]),
          );

          await addToCartController.addItem(testItem.productId);

          verify(cartService.addItem(testItem)).called(1);
        },
      );

      test(
        'failure',
        () async {
          when(cartService.addItem(testItem)).thenThrow(exception);

          expect(
            addToCartController.stream,
            emitsInOrder([
              const AsyncLoading<int>().copyWithPrevious(const AsyncData<int>(1)),
              predicate<AsyncValue<int>>((value) {
                expect(value.hasError, true);
                return true;
              }),
            ]),
          );

          await addToCartController.addItem(testItem.productId);

          verify(cartService.addItem(testItem)).called(1);
        },
      );
    },
  );
}

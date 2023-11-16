import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  testWidgets(
    'Empty shopping cart',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        robot.products.expectProductsListLoaded();
        await robot.cart.openCart();
        robot.cart.expectEmptyShoppingCart();
      });
    },
  );

  testWidgets(
    'Add product with quantity = 1',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.cart.addToCart();
        await robot.cart.openCart();
        robot.cart.expectItemQuantity(quantity: 1, atIndex: 0);
        robot.cart.expectShoppingCartTotalIs('Total: \$15.00');
      });
    },
  );

  testWidgets(
    'Add product with quantity = 5',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.products.setProductQuantity(5);
        await robot.cart.addToCart();
        await robot.cart.openCart();
        robot.cart.expectItemQuantity(quantity: 5, atIndex: 0);
        robot.cart.expectShoppingCartTotalIs('Total: \$75.00');
      });
    },
  );

  testWidgets(
    'Add product with quantity = 6',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.products.setProductQuantity(6);
        await robot.cart.addToCart();
        await robot.cart.openCart();
        robot.cart.expectItemQuantity(quantity: 5, atIndex: 0);
        robot.cart.expectShoppingCartTotalIs('Total: \$75.00');
      });
    },
  );

  testWidgets(
    'Add product with quantity = 2, then increment by 2',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.products.setProductQuantity(2);
        await robot.cart.addToCart();
        await robot.cart.openCart();
        await robot.cart.incrementQuantity(quantity: 2, atIndex: 0);
        robot.cart.expectItemQuantity(quantity: 4, atIndex: 0);
        robot.cart.expectShoppingCartTotalIs('Total: \$60.00');
      });
    },
  );

  testWidgets(
    'Add product with quantity = 5, then decrement by 2',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.products.setProductQuantity(5);
        await robot.cart.addToCart();
        await robot.cart.openCart();
        await robot.cart.decrementQuantity(quantity: 2, atIndex: 0);
        robot.cart.expectItemQuantity(quantity: 3, atIndex: 0);
        robot.cart.expectShoppingCartTotalIs('Total: \$45.00');
      });
    },
  );

  testWidgets(
    'Add two products',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();

        //1
        await robot.products.selectProduct();
        await robot.cart.addToCart();
        await robot.goBack();

        //2
        await robot.products.selectProduct(atIndex: 1);
        await robot.cart.addToCart();

        await robot.cart.openCart();
        robot.cart.expectItemQuantity(quantity: 1, atIndex: 0);
        robot.cart.expectItemQuantity(quantity: 1, atIndex: 1);
        robot.cart.expectFindNCartItems(count: 2);
        robot.cart.expectShoppingCartTotalIs('Total: \$28.00');
      });
    },
  );

  testWidgets(
    'Add product, then delete it',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.cart.addToCart();
        await robot.cart.openCart();
        await robot.cart.deleteProductAtIndex(atIndex: 0);
        robot.cart.expectFindNCartItems(count: 0);
        robot.cart.expectEmptyShoppingCart();
      });
    },
  );

  testWidgets(
    'Add product with quantity = 5, goes out of stock',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.products.setProductQuantity(5);
        await robot.cart.addToCart();
        robot.cart.expectItemOutOfStock();
      });
    },
  );

  testWidgets(
    'Add product with quantity, remains out of stock when opened again',
    (tester) async {
      final robot = Robot(tester);

      await tester.runAsync(() async {
        await robot.pumpMyAppWithFakes();
        await robot.products.selectProduct();
        await robot.products.setProductQuantity(5);
        await robot.cart.addToCart();
        robot.cart.expectItemOutOfStock();
        await robot.goBack();
        await robot.products.selectProduct();
        robot.cart.expectItemOutOfStock();
      });
    },
  );
}

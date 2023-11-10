import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Full purchase flow',
    (tester) async {
      final robot = Robot(tester);

      await robot.pumpMyApp();
      robot.products.expectFindAllProductCards();

      //add to cart
      await robot.products.selectProduct();
      await robot.products.setProductQuantity(quantity: 3);
      await robot.cart.addToCart();
      await robot.cart.openCart();
      robot.cart.expectItemQuantity(quantity: 3, atIndex: 0);

      //checkout
      await robot.checkout.startCheckout();
      robot.auth.expectEmailAndPasswordFieldsFound();
      await robot.auth.signInWithEmailAndPassword();
      robot.cart.expectFindNCartItems(count: 1);
      await robot.checkout.startPayment();

      //orders are plcaed
      robot.orders.expectNOrderItems();
      await robot.closePage();

      //cart is empty
      await robot.cart.openCart();
      robot.cart.expectEmptyShoppingCart();
      await robot.closePage();

      //logout
      await robot.openPopupMenu();
      await robot.auth.openAccountScreen();
      await robot.auth.tapLogoutButton();
      await robot.auth.tapDialogLogoutButton();
      robot.products.expectFindAllProductCards();
    },
    skip: true,
  );
}

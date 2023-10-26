import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  testWidgets(
    'Full purchase, sign in and sign out flow, with products remaning in cart after sign in',
    (tester) async {
      final robot = Robot(tester);

      await robot.pumpMyApp();
      robot.products.expectFindAllProductCards();

      await robot.products.selectProduct();
      await robot.products.setProductQuantity(quantity: 3);
      await robot.cart.addToCart();
      await robot.cart.openCart();
      robot.cart.expectItemQuantity(quantity: 3, atIndex: 0);
      await robot.closePage();

      await robot.openPopupMenu();
      await robot.auth.openEmailPasswordSignInScreen();
      await robot.auth.signInWithEmailAndPassword();
      robot.products.expectFindAllProductCards();

      await robot.cart.openCart();
      robot.cart.expectFindNCartItems(count: 1);
      await robot.closePage();

      await robot.openPopupMenu();
      await robot.auth.openAccountScreen();
      await robot.auth.tapLogoutButton();
      await robot.auth.tapDialogLogoutButton();
      robot.products.expectFindAllProductCards();
    },
  );
}

import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  testWidgets(
    'checkout when not previously signed in',
    (tester) async {
      final robot = Robot(tester);

      await robot.pumpMyApp();
      await robot.products.selectProduct();
      await robot.cart.addToCart();
      await robot.cart.openCart();
      await robot.checkout.startCheckout();

      robot.auth.expectEmailAndPasswordFieldsFound();
      await robot.auth.enterAndSubmitEmailAndPassword();

      robot.checkout.expectPayButtonFound();
    },
  );

  testWidgets(
    'checkout when previously signed in',
    (tester) async {
      final robot = Robot(tester);

      await robot.pumpMyApp();
      await robot.auth.openEmailPasswordSignInScreen();
      await robot.auth.tapOnNeedAnAccountButton();
      await robot.auth.enterAndSubmitEmailAndPassword();

      await robot.products.selectProduct();
      await robot.cart.addToCart();
      await robot.cart.openCart();
      await robot.checkout.startCheckout();

      robot.checkout.expectPayButtonFound();
    },
  );
}

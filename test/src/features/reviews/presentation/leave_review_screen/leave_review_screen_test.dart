import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  Future<void> purchaseProduct(Robot robot) async {
    await robot.products.selectProduct();
    await robot.products.setProductQuantity(quantity: 3);
    await robot.cart.addToCart();
    await robot.cart.openCart();
    robot.cart.expectItemQuantity(quantity: 3, atIndex: 0);
    await robot.checkout.startCheckout();
    robot.auth.expectEmailAndPasswordFieldsFound();
    await robot.auth.enterAndSubmitEmailAndPassword();
    robot.cart.expectFindNCartItems(count: 1);
    await robot.checkout.startPayment();
    robot.orders.expectNOrderItems();
    await robot.closePage();
  }

  testWidgets(
    'purchase product, leave review, update it',
    (tester) async {
      final robot = Robot(tester);

      await robot.pumpMyApp();
      await purchaseProduct(robot);
      await robot.products.selectProduct();

      robot.reviews.expectFindLeaveReview();
      await robot.reviews.tapLeaveReview();
      await robot.reviews.createAndSubmitReview('Love it!');
      robot.reviews.expectOneReviewFound();
      robot.reviews.expectFindText('Love it!');

      robot.reviews.expectFindUpdateReview();
      await robot.reviews.tapUpdateReview();
      await robot.reviews.updateAndSubmitReview('Great!');
      robot.reviews.expectOneReviewFound();
      robot.reviews.expectFindText('Great!');
    },
  );
}

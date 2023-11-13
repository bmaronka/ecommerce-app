import 'package:flutter_test/flutter_test.dart';

import '../robot.dart';

void main() {
  testWidgets(
    '''Full purchase;
       sign in and sign out flow;  
       products remaning in cart after sign in;
       leaving review;
    ''',
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
      await robot.auth.enterAndSubmitEmailAndPassword();
      robot.cart.expectFindNCartItems(count: 1);
      await robot.checkout.startPayment();

      //orders are plcaed
      robot.orders.expectNOrderItems();
      await robot.closePage();

      //cart is empty
      await robot.cart.openCart();
      robot.cart.expectEmptyShoppingCart();
      await robot.closePage();

      //leave review
      await robot.products.selectProduct();
      robot.reviews.expectFindLeaveReview();
      await robot.reviews.tapLeaveReview();
      await robot.reviews.createAndSubmitReview('Love it!');
      robot.reviews.expectOneReviewFound();
      robot.reviews.expectFindText('Love it!');

      //logout
      await robot.openPopupMenu();
      await robot.auth.openAccountScreen();
      await robot.auth.tapLogoutButton();
      await robot.auth.tapDialogLogoutButton();
      robot.products.expectFindAllProductCards();
    },
  );
}

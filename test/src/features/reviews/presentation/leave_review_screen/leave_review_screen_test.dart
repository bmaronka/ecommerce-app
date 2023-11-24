

// void main() {
//   Future<void> purchaseProduct(Robot robot) async {
//     await robot.products.selectProduct();
//     await robot.products.setProductQuantity(3);
//     await robot.cart.addToCart();
//     await robot.cart.openCart();
//     robot.cart.expectFindNCartItems(count: 1);

//     await robot.checkout.startCheckout();

//     await robot.auth.enterAndSubmitEmailAndPassword();

//     robot.cart.expectFindNCartItems(count: 1);
//     await robot.checkout.startPayment();

//     robot.orders.expectFindNOrders(1);
//     await robot.closePage();
//   }

//   testWidgets(
//     'purchase product, leave review, update it',
//     (tester) async {
//       final robot = Robot(tester);

//       await tester.runAsync(() async {
//         await robot.pumpMyAppWithFakes();
//         await purchaseProduct(robot);
         // await robot.products.selectProduct();

         // robot.reviews.expectFindLeaveReview();
         // await robot.reviews.tapLeaveReview();
         // await robot.reviews.createAndSubmitReview('Love it!');
         // robot.reviews.expectOneReviewFound();
         // robot.reviews.expectFindText('Love it!');

         // robot.reviews.expectFindUpdateReview();
         // await robot.reviews.tapUpdateReview();
         // await robot.reviews.updateAndSubmitReview('Great!');
         // robot.reviews.expectOneReviewFound();
         // robot.reviews.expectFindText('Great!');
//       });
//     },
//   );
// }

import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/app_bootstrap_fakes.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'features/authantication/auth_robot.dart';
import 'features/cart/cart_robot.dart';
import 'features/checkout/checkout_robot.dart';
import 'features/orders/orders_robot.dart';
import 'features/products/products_robot.dart';
import 'features/products_admin/products_admin_robot.dart';
import 'features/reviews/reviews_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        cart = CartRobot(tester),
        products = ProductsRobot(tester),
        checkout = CheckoutRobot(tester),
        orders = OrdersRobot(tester),
        reviews = ReviewsRobot(tester),
        productsAdmin = ProductsAdminRobot(tester),
        golden = GoldenRobot(tester);

  final WidgetTester tester;
  final AuthRobot auth;
  final CartRobot cart;
  final ProductsRobot products;
  final CheckoutRobot checkout;
  final OrdersRobot orders;
  final ReviewsRobot reviews;
  final ProductsAdminRobot productsAdmin;
  final GoldenRobot golden;

  Future<void> pumpMyAppWithFakes() async {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    final container = await createFakesProviderContainer(addDelay: false);
    container.read(cartSyncServiceProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  //TODO waiting for idTokenChanges added to MockFirebaseAuth
  // Future<void> pumpMyAppWithMockedFirebase() async {
  //   GoRouter.optionURLReflectsImperativeAPIs = true;
  //   final container = await createMockedFirebaseProviderContainer(addDelay: false);
  //   container.read(cartSyncServiceProvider);

  //   await tester.pumpWidget(
  //     UncontrolledProviderScope(
  //       container: container,
  //       child: const MyApp(),
  //     ),
  //   );
  //   await tester.pumpAndSettle();
  // }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();

    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
  }

  Future<void> goBack() async {
    final finder = find.byType(BackButton);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> closePage() async {
    final finder = find.byType(CloseButton);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> fullPurchaseFlow() async {
    products.expectProductsListLoaded();

    //add to cart
    await products.selectProduct();
    await products.setProductQuantity(3);
    await cart.addToCart();
    await cart.openCart();
    cart.expectItemQuantity(quantity: 3, atIndex: 0);

    //checkout
    await checkout.startCheckout();
    auth.expectEmailAndPasswordFieldsFound();
    await auth.enterAndSubmitEmailAndPassword();
    cart.expectFindNCartItems(count: 1);
    await checkout.startPayment();

    //orders are plcaed
    orders.expectNOrderItems();
    await closePage();

    //cart is empty
    await cart.openCart();
    cart.expectEmptyShoppingCart();
    await closePage();

    //leave review
    await products.selectProduct();
    reviews.expectFindLeaveReview();
    await reviews.tapLeaveReview();
    await reviews.createAndSubmitReview('Love it!');
    reviews.expectOneReviewFound();
    await reviews.scrollToAddedReview('Love it!');
    reviews.expectFindText('Love it!');

    //logout
    await openPopupMenu();
    await auth.openAccountScreen();
    await auth.tapLogoutButton();
    await auth.tapDialogLogoutButton();
    products.expectProductsListLoaded();
  }
}

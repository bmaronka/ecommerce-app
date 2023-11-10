import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/fake_local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
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
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        cart = CartRobot(tester),
        products = ProductsRobot(tester),
        golden = GoldenRobot(tester),
        checkout = CheckoutRobot(tester),
        orders = OrdersRobot(tester);

  final WidgetTester tester;
  final AuthRobot auth;
  final CartRobot cart;
  final ProductsRobot products;
  final GoldenRobot golden;
  final CheckoutRobot checkout;
  final OrdersRobot orders;

  Future<void> pumpMyApp() async {
    final productsRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);
    final localCartRepository = FakeLocalCartRepository(addDelay: false);
    final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);

    GoRouter.optionURLReflectsImperativeAPIs = true;

    final container = ProviderContainer(
      overrides: [
        productsRepositoryProvider.overrideWithValue(productsRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
      ],
    );

    container.read(cartSyncServiceProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

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
}

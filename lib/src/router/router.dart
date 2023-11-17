import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/account/account_screen.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_form_type.dart';
import 'package:ecommerce_app/src/features/authantication/presentation/sign_in/email_password_sign_in_screen.dart';
import 'package:ecommerce_app/src/features/cart/presentation/shopping_cart/shopping_cart_screen.dart';
import 'package:ecommerce_app/src/features/checkout/presentation/checkout_screen/checkout_screen.dart';
import 'package:ecommerce_app/src/features/orders/presentation/orders_list/orders_list_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/product_screen/product_screen.dart';
import 'package:ecommerce_app/src/features/products/presentation/products_list/products_list_screen.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_screen.dart';
import 'package:ecommerce_app/src/router/go_router_refresh_stream.dart';
import 'package:ecommerce_app/src/router/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

enum AppRoute {
  home,
  product,
  leaveReview,
  cart,
  checkout,
  orders,
  account,
  signIn,
  admin,
  // adminAdd,
  // adminUploadProduct,
  // adminEditProduct,
}

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);

  return _buildRouter(authRepo);
}

GoRouter _buildRouter(AuthRepository authRepository) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: false,
      redirect: (context, state) => _redirect(context, state, authRepository),
      refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
      routes: _routes,
      errorBuilder: (context, state) => NotFoundScreen(),
    );

FutureOr<String?> _redirect(BuildContext context, GoRouterState state, AuthRepository authRepository) {
  final path = state.uri.path;
  final isLoggedIn = authRepository.currentUser != null;

  if (isLoggedIn) {
    if (path == '/signIn') {
      return '/';
    }
  } else {
    if (path == '/account' || path == '/orders') {
      return '/';
    }
  }
  return null;
}

List<RouteBase> get _routes => [
      GoRoute(
        path: '/',
        name: AppRoute.home.name,
        builder: (context, state) => ProductsListScreen(),
        routes: [
          GoRoute(
            path: 'product/:id',
            name: AppRoute.product.name,
            builder: (context, state) {
              final productId = state.pathParameters['id']!;
              return ProductScreen(productId: productId);
            },
            routes: [
              GoRoute(
                path: 'review',
                name: AppRoute.leaveReview.name,
                pageBuilder: (context, state) {
                  final productId = state.pathParameters['id']!;
                  return MaterialPage(
                    fullscreenDialog: true,
                    child: LeaveReviewScreen(productId: productId),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: 'cart',
            name: AppRoute.cart.name,
            pageBuilder: (context, state) => MaterialPage(
              fullscreenDialog: true,
              child: ShoppingCartScreen(),
            ),
            routes: [
              GoRoute(
                path: 'checkout',
                name: AppRoute.checkout.name,
                pageBuilder: (context, state) => MaterialPage(
                  fullscreenDialog: true,
                  child: CheckoutScreen(),
                ),
              ),
            ],
          ),
          GoRoute(
            path: 'orders',
            name: AppRoute.orders.name,
            pageBuilder: (context, state) => MaterialPage(
              fullscreenDialog: true,
              child: OrdersListScreen(),
            ),
          ),
          GoRoute(
            path: 'account',
            name: AppRoute.account.name,
            pageBuilder: (context, state) => MaterialPage(
              fullscreenDialog: true,
              child: AccountScreen(),
            ),
          ),
          GoRoute(
            path: 'signIn',
            name: AppRoute.signIn.name,
            pageBuilder: (context, state) => MaterialPage(
              fullscreenDialog: true,
              child: EmailPasswordSignInScreen(
                formType: EmailPasswordSignInFormType.signIn,
              ),
            ),
          ),
          GoRoute(
            path: 'admin',
            name: AppRoute.admin.name,
            pageBuilder: (context, state) => const MaterialPage(
              fullscreenDialog: true,
              child: const SizedBox.shrink(),
            ),
            routes: [
              //TODO
              // GoRoute(
              //   path: 'add',
              //   name: AppRoute.adminAdd.name,
              //   pageBuilder: (context, state) => const MaterialPage(
              //     fullscreenDialog: true,
              //     child: AdminProductsAddScreen(),
              //   ),
              //   routes: [
              //     GoRoute(
              //       path: ':id',
              //       name: AppRoute.adminUploadProduct.name,
              //       builder: (context, state) {
              //         final productId = state.pathParameters['id']!;
              //         return AdminProductUploadScreen(productId: productId);
              //       },
              //     ),
              //   ],
              // ),
              // GoRoute(
              //   path: 'edit/:id',
              //   name: AppRoute.adminEditProduct.name,
              //   pageBuilder: (context, state) {
              //     final productId = state.pathParameters['id']!;
              //     return MaterialPage(
              //       fullscreenDialog: true,
              //       child: AdminProductEditScreen(productId: productId),
              //     );
              //   },
              // ),
            ],
          ),
        ],
      ),
    ];

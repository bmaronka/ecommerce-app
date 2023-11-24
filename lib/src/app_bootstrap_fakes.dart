import 'package:ecommerce_app/src/app_bootstrap.dart';
import 'package:ecommerce_app/src/exceptions/async_error_logger.dart';
import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/fake_local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/checkout/application/checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/orders_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/reviews/application/fake_reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/data/reviews_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AppBootstrapFakes on AppBootstrap {
  Future<ProviderContainer> createFakesProviderContainer({bool addDelay = true}) async {
    // repositories
    final authRepository = FakeAuthRepository(addDelay: addDelay);
    final productsRepository = FakeProductsRepository(addDelay: addDelay);
    final reviewsRepository = FakeReviewsRepository(addDelay: addDelay);
    final localCartRepository = FakeLocalCartRepository(addDelay: false);
    final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);
    final ordersRepository = FakeOrdersRepository(addDelay: addDelay);

    // services
    final checkoutService = FakeCheckoutService(
      fakeAuthRepository: authRepository,
      remoteCartRepository: remoteCartRepository,
      fakeOrdersRepository: ordersRepository,
      fakeProductsRepository: productsRepository,
      dateBuilder: DateTime.now,
    );
    final reviewsService = FakeReviewsService(
      fakeProductsRepository: productsRepository,
      fakeAuthRepository: authRepository,
      fakeReviewsRepository: reviewsRepository,
    );

    return ProviderContainer(
      overrides: [
        // repositories
        authRepositoryProvider.overrideWithValue(authRepository),
        productsRepositoryProvider.overrideWithValue(productsRepository),
        reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
        ordersRepositoryProvider.overrideWithValue(ordersRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
        // services
        checkoutServiceProvider.overrideWithValue(checkoutService),
        reviewsServiceProvider.overrideWithValue(reviewsService),
      ],
      observers: [AsyncErrorLogger()],
    );
  }
}

//TODO waiting for idTokenChanges added to MockFirebaseAuth
// const email = 'test@test.com';
// final mockUser = MockUser(
//   email: email,
//   uid: email.split('').reversed.join(),
// );

// Future<ProviderContainer> createMockedFirebaseProviderContainer({bool addDelay = true}) async {
//   final authRepository = AuthRepository(MockFirebaseAuth(mockUser: mockUser));
//   final productsRepository = ProductsRepository(FakeFirebaseFirestore());
//   final imageUploadRepository = ImageUploadRepository(MockFirebaseStorage());
//   final reviewsRepository = FakeReviewsRepository(addDelay: addDelay);
//   final localCartRepository = FakeLocalCartRepository(addDelay: false);
//   final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);
//   final ordersRepository = FakeOrdersRepository(addDelay: addDelay);

//   final manageProductService = ManageProductService(
//     productsRepository: productsRepository,
//     imageUploadRepository: imageUploadRepository,
//   );

//   return ProviderContainer(
//     overrides: [
//       authRepositoryProvider.overrideWithValue(authRepository),
//       productsRepositoryProvider.overrideWithValue(productsRepository),
//       reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
//       ordersRepositoryProvider.overrideWithValue(ordersRepository),
//       localCartRepositoryProvider.overrideWithValue(localCartRepository),
//       remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
//       imageUploadRepositoryProvider.overrideWithValue(imageUploadRepository),
//       manageProductServiceProvider.overrideWithValue(manageProductService),
//     ],
//     observers: [AsyncErrorLogger()],
//   );
// }

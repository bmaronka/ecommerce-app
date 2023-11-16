import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockFakeAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;
  late MockFakeProductsRepository productsRepository;

  setUp(() {
    authRepository = MockFakeAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();
    productsRepository = MockFakeProductsRepository();
  });

  void makeCartSyncService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        productsRepositoryProvider.overrideWithValue(productsRepository),
      ],
    );

    addTearDown(container.dispose);
    return container.read(cartSyncServiceProvider);
  }

  Future<void> runCartSyncTest({
    required Map<ProductID, int> localCartItems,
    required Map<ProductID, int> remoteCartItems,
    required Map<ProductID, int> expectedRemoteCartItems,
  }) async {
    const uid = '123';
    when(authRepository.authStateChanges()).thenAnswer(
      (_) => Stream.value(
        AppUser(
          uid: uid,
          email: 'test@test.pl',
        ),
      ),
    );
    when(productsRepository.fetchProductsList()).thenAnswer((_) => Future.value(kTestProducts));
    when(localCartRepository.fetchCart()).thenAnswer((_) => Future.value(Cart(localCartItems)));
    when(remoteCartRepository.fetchCart(uid)).thenAnswer((_) => Future.value(Cart(remoteCartItems)));
    when(remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems))).thenAnswer((_) => Future.value());
    when(localCartRepository.setCart(const Cart())).thenAnswer((_) => Future.value());

    makeCartSyncService();
    await Future.delayed(const Duration());

    verify(remoteCartRepository.setCart(uid, Cart(expectedRemoteCartItems))).called(1);
    verify(localCartRepository.setCart(const Cart())).called(1);
  }

  test(
    'local quantity <= available quantity',
    () async => runCartSyncTest(
      localCartItems: {'1': 1},
      remoteCartItems: {},
      expectedRemoteCartItems: {'1': 1},
    ),
  );

  test(
    'local quantity > available quantity',
    () async => runCartSyncTest(
      localCartItems: {'1': 15},
      remoteCartItems: {},
      expectedRemoteCartItems: {'1': 5},
    ),
  );

  test(
    'local + remote quantity <= available quantity',
    () async => runCartSyncTest(
      localCartItems: {'1': 1},
      remoteCartItems: {'1': 1},
      expectedRemoteCartItems: {'1': 2},
    ),
  );

  test(
    'local + remote quantity > available quantity',
    () async => runCartSyncTest(
      localCartItems: {'1': 3},
      remoteCartItems: {'1': 3},
      expectedRemoteCartItems: {'1': 5},
    ),
  );

  test(
    'multiple items',
    () async => runCartSyncTest(
      localCartItems: {'1': 3, '2': 1, '3': 2},
      remoteCartItems: {'1': 3},
      expectedRemoteCartItems: {'1': 5, '2': 1, '3': 2},
    ),
  );
}

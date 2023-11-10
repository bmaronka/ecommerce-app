import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;
  late RemoteCartRepository remoteCartRepository;
  late FakeOrdersRepository fakeOrdersRepository;
  late FakeProductsRepository fakeProductsRepository;

  const testUser = AppUser(uid: 'abc');
  final orderDate = DateTime(2023);
  final orderId = orderDate.toIso8601String();
  final testOrder = Order(
    id: orderId,
    userId: testUser.uid,
    items: {
      '1': 1,
    },
    orderStatus: OrderStatus.confirmed,
    orderDate: orderDate,
    total: 1.0,
  );
  const testProduct = Product(
    id: '1',
    imageUrl: '',
    title: 'test',
    description: 'test',
    price: 1.0,
    availableQuantity: 1,
  );

  setUp(() {
    fakeAuthRepository = MockFakeAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    fakeOrdersRepository = MockFakeOrdersRepository();
    fakeProductsRepository = MockFakeProductsRepository();
  });

  FakeCheckoutService makeCheckoutService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(fakeAuthRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
        ordersRepositoryProvider.overrideWithValue(fakeOrdersRepository),
        productsRepositoryProvider.overrideWithValue(fakeProductsRepository),
      ],
    );
    addTearDown(container.dispose);

    return container.read(checkoutServiceProvider);
  }

  test(
    'null user throws',
    () {
      when(fakeAuthRepository.currentUser).thenReturn(null);
      final checkoutService = makeCheckoutService();

      expect(checkoutService.placeOrder(), throwsA(isA<TypeError>()));
    },
  );

  test('empty cart, throws', () async {
    when(fakeAuthRepository.currentUser).thenReturn(testUser);
    when(remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart()));
    final checkoutService = makeCheckoutService();

    expect(checkoutService.placeOrder, throwsStateError);
  });

  test(
    'non-empty cart, creates order',
    () async {
      when(fakeAuthRepository.currentUser).thenReturn(testUser);
      when(remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart({'1': 1})));
      when(fakeProductsRepository.getProduct('1')).thenReturn(testProduct);
      final checkoutService = makeCheckoutService();

      await checkoutService.placeOrder();

      verify(fakeOrdersRepository.addOrder(testUser.uid, testOrder)).called(1);
      verify(remoteCartRepository.setCart(testUser.uid, const Cart()));
    },
  );
}

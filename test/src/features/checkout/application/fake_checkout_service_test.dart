import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/checkout/application/checkout_service.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;
  late RemoteCartRepository remoteCartRepository;
  late FakeOrdersRepository fakeOrdersRepository;
  late FakeProductsRepository fakeProductsRepository;

  late CheckoutService checkoutService;

  const testUser = AppUser(uid: 'abc');
  final testDate = DateTime(2022, 7, 13);
  final orderId = testDate.toIso8601String();
  final testOrder = Order(
    id: orderId,
    userId: testUser.uid,
    items: {
      '1': 1,
    },
    orderStatus: OrderStatus.confirmed,
    orderDate: testDate,
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

    checkoutService = FakeCheckoutService(
      fakeAuthRepository: fakeAuthRepository,
      remoteCartRepository: remoteCartRepository,
      fakeOrdersRepository: fakeOrdersRepository,
      fakeProductsRepository: fakeProductsRepository,
      dateBuilder: () => testDate,
    );
  });

  test(
    'null user throws',
    () {
      when(fakeAuthRepository.currentUser).thenReturn(null);

      expect(checkoutService.placeOrder(), throwsA(isA<TypeError>()));
    },
  );

  test('empty cart, throws', () async {
    when(fakeAuthRepository.currentUser).thenReturn(testUser);
    when(remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart()));

    expect(checkoutService.placeOrder, throwsStateError);
  });

  test(
    'non-empty cart, creates order',
    () async {
      when(fakeAuthRepository.currentUser).thenReturn(testUser);
      when(remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart({'1': 1})));
      when(fakeProductsRepository.getProduct('1')).thenReturn(testProduct);

      await checkoutService.placeOrder();

      verify(fakeOrdersRepository.addOrder(testUser.uid, testOrder)).called(1);
      verify(remoteCartRepository.setCart(testUser.uid, const Cart()));
    },
  );
}

import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late MockFakeAuthRepository authRepository;
  late MockRemoteCartRepository remoteCartRepository;
  late MockLocalCartRepository localCartRepository;

  late CartService cartService;

  const testCart = Cart({'123': 5});
  const testUser = AppUser(uid: '123', email: 'test@test.com');
  const testItem = Item(productId: '123', quantity: 5);

  setUp(() {
    authRepository = MockFakeAuthRepository();
    remoteCartRepository = MockRemoteCartRepository();
    localCartRepository = MockLocalCartRepository();

    cartService = CartService(
      authRepository: authRepository,
      localCartRepository: localCartRepository,
      remoteCartRepository: remoteCartRepository,
    );
  });

  group(
    'setItem',
    () {
      test(
        'null user, writes item to local cart',
        () async {
          when(authRepository.currentUser).thenReturn(null);
          when(localCartRepository.fetchCart()).thenAnswer((_) => Future.value(const Cart()));
          when(localCartRepository.setCart(testCart)).thenAnswer((_) => Future.value());

          await cartService.setItem(testItem);

          verify(localCartRepository.setCart(testCart)).called(1);
          verifyNever(remoteCartRepository.setCart(any, any));
        },
      );

      test(
        'non-null user, writes item to remote cart',
        () async {
          when(authRepository.currentUser).thenReturn(testUser);
          when(remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart()));
          when(remoteCartRepository.setCart(testUser.uid, testCart)).thenAnswer((_) => Future.value());

          await cartService.setItem(testItem);

          verify(remoteCartRepository.setCart(testUser.uid, testCart)).called(1);
          verifyNever(localCartRepository.setCart(any));
        },
      );
    },
  );

  group(
    'addItem',
    () {
      test(
        'null user, adds item to local cart',
        () async {
          when(authRepository.currentUser).thenReturn(null);
          when(localCartRepository.fetchCart()).thenAnswer((_) => Future.value(const Cart()));
          when(localCartRepository.setCart(testCart)).thenAnswer((_) => Future.value());

          await cartService.addItem(testItem);

          verify(localCartRepository.setCart(testCart)).called(1);
          verifyNever(remoteCartRepository.setCart(any, any));
        },
      );

      test(
        'non-null user, adds item to remote cart',
        () async {
          when(authRepository.currentUser).thenReturn(testUser);
          when(remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(const Cart()));
          when(remoteCartRepository.setCart(testUser.uid, testCart)).thenAnswer((_) => Future.value());

          await cartService.addItem(testItem);

          verify(remoteCartRepository.setCart(testUser.uid, testCart)).called(1);
          verifyNever(localCartRepository.setCart(any));
        },
      );
    },
  );

  group(
    'removeItemById',
    () {
      test(
        'null user, removes item from local cart',
        () async {
          when(authRepository.currentUser).thenReturn(null);
          when(localCartRepository.fetchCart()).thenAnswer((_) => Future.value(testCart));

          await cartService.removeItemById('123');

          verify(localCartRepository.setCart(const Cart())).called(1);
          verifyNever(remoteCartRepository.setCart(any, any));
        },
      );

      test(
        'non-null user, removes item from remote cart',
        () async {
          when(authRepository.currentUser).thenReturn(testUser);
          when(remoteCartRepository.fetchCart(testUser.uid)).thenAnswer((_) => Future.value(testCart));

          await cartService.removeItemById('123');

          verify(remoteCartRepository.setCart(testUser.uid, const Cart())).called(1);
          verifyNever(localCartRepository.setCart(any));
        },
      );
    },
  );
}

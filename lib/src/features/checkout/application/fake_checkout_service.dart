import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_checkout_service.g.dart';

class FakeCheckoutService {
  FakeCheckoutService({
    required this.fakeAuthRepository,
    required this.remoteCartRepository,
    required this.fakeOrdersRepository,
    required this.fakeProductsRepository,
    required this.dateBuilder,
  });

  final FakeAuthRepository fakeAuthRepository;
  final RemoteCartRepository remoteCartRepository;
  final FakeOrdersRepository fakeOrdersRepository;
  final FakeProductsRepository fakeProductsRepository;
  final DateTime Function() dateBuilder;

  Future<void> placeOrder() async {
    final uid = fakeAuthRepository.currentUser!.uid;
    final cart = await remoteCartRepository.fetchCart(uid);

    if (cart.items.isNotEmpty) {
      final total = _totalPrice(cart);

      final orderDate = dateBuilder();
      final orderId = orderDate.toIso8601String();
      final order = Order(
        id: orderId,
        userId: uid,
        items: cart.items,
        orderStatus: OrderStatus.confirmed,
        orderDate: orderDate,
        total: total,
      );

      await fakeOrdersRepository.addOrder(uid, order);
      await remoteCartRepository.setCart(uid, const Cart());
    } else {
      throw StateError('Can\'t place an order if the cart is empty'.hardcoded);
    }
  }

  double _totalPrice(Cart cart) {
    if (cart.items.isEmpty) {
      return 0.0;
    }

    return cart.items.entries
        .map(
          (entry) => entry.value * fakeProductsRepository.getProduct(entry.key)!.price,
        )
        .reduce((value, element) => value + element);
  }
}

@riverpod
FakeCheckoutService checkoutService(CheckoutServiceRef ref) => FakeCheckoutService(
      fakeAuthRepository: ref.read(authRepositoryProvider),
      remoteCartRepository: ref.read(remoteCartRepositoryProvider),
      fakeOrdersRepository: ref.read(ordersRepositoryProvider),
      fakeProductsRepository: ref.read(productsRepositoryProvider),
      dateBuilder: ref.read(currentDateBuilderProvider),
    );

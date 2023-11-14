import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_service.g.dart';

class CartService {
  const CartService({
    required this.authRepository,
    required this.localCartRepository,
    required this.remoteCartRepository,
  });

  final FakeAuthRepository authRepository;
  final LocalCartRepository localCartRepository;
  final RemoteCartRepository remoteCartRepository;

  Future<Cart> _fetchCart() async {
    final user = authRepository.currentUser;

    if (user != null) {
      return remoteCartRepository.fetchCart(user.uid);
    }

    return localCartRepository.fetchCart();
  }

  Future<void> _setCart(Cart cart) async {
    final user = authRepository.currentUser;

    if (user != null) {
      return remoteCartRepository.setCart(user.uid, cart);
    }

    return localCartRepository.setCart(cart);
  }

  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.setItem(item);
    await _setCart(updated);
  }

  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updated = cart.addItem(item);
    await _setCart(updated);
  }

  Future<void> removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final updated = cart.removeItemById(productId);
    await _setCart(updated);
  }
}

@Riverpod(keepAlive: true)
CartService cartService(CartServiceRef ref) => CartService(
      authRepository: ref.watch(authRepositoryProvider),
      localCartRepository: ref.watch(localCartRepositoryProvider),
      remoteCartRepository: ref.watch(remoteCartRepositoryProvider),
    );

@Riverpod(keepAlive: true)
Stream<Cart> cart(CartRef ref) {
  final user = ref.watch(authStateChangesProvider).value;

  if (user != null) {
    return ref.watch(remoteCartRepositoryProvider).watchCart(user.uid);
  }

  return ref.watch(localCartRepositoryProvider).watchCart();
}

@Riverpod(keepAlive: true)
int cartItemsCount(CartItemsCountRef ref) => ref.watch(cartProvider).maybeWhen(
      data: (cart) => cart.items.length,
      orElse: () => 0,
    );

@riverpod
double cartTotal(CartTotalRef ref) {
  final cart = ref.watch(cartProvider).value ?? const Cart();
  final productList = ref.watch(productsListStreamProvider).value ?? [];

  if (cart.items.isNotEmpty && productList.isNotEmpty) {
    return cart.items.entries
        .map((item) => item.value * _findProductPrice(productList, item.key))
        .reduce((value, element) => value + element);
  }

  return 0.0;
}

double _findProductPrice(List<Product> products, String productId) =>
    products.firstWhereOrNull((product) => product.id == productId)?.price ?? 0.0;

@riverpod
int itemAvailableQuantity(ItemAvailableQuantityRef ref, Product product) {
  final cart = ref.watch(cartProvider).value;

  if (cart != null) {
    final quantity = cart.items[product.id] ?? 0;
    return max(0, product.availableQuantity - quantity);
  }

  return product.availableQuantity;
}

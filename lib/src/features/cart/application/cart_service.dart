import 'dart:math';

import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_service.g.dart';

class CartService {
  const CartService({
    required this.authRepository,
    required this.localCartRepository,
    required this.remoteCartRepository,
  });

  final AuthRepository authRepository;
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
Future<double> cartTotal(CartTotalRef ref) async {
  final cart = await ref.watch(cartProvider.future);

  if (cart.items.isNotEmpty) {
    double total = 0.0;

    for (final item in cart.items.entries) {
      final product = await ref.watch(productStreamProvider(item.key).future);

      if (product != null) {
        total += item.value * product.price;
      }
    }

    return total;
  }

  return 0.0;
}

@riverpod
int itemAvailableQuantity(ItemAvailableQuantityRef ref, Product product) {
  final cart = ref.watch(cartProvider).value;

  if (cart != null) {
    final quantity = cart.items[product.id] ?? 0;
    return max(0, product.availableQuantity - quantity);
  }

  return product.availableQuantity;
}

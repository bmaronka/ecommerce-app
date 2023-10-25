import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final cartServiceProvider = Provider<CartService>(
  (ref) => CartService(
    authRepository: ref.watch(authRepositoryProvider),
    localCartRepository: ref.watch(localCartRepositoryProvider),
    remoteCartRepository: ref.watch(remoteCartRepositoryProvider),
  ),
);

final cartProvider = StreamProvider<Cart>((ref) {
  final user = ref.watch(authStateChangesProvider).value;

  if (user != null) {
    return ref.watch(remoteCartRepositoryProvider).watchCart(user.uid);
  }

  return ref.watch(localCartRepositoryProvider).watchCart();
});

final cartItemsCountProvider = Provider<int>(
  (ref) => ref.watch(cartProvider).maybeWhen(
        data: (cart) => cart.items.length,
        orElse: () => 0,
      ),
);
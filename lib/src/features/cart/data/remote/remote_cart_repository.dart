import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteCartRepository {
  Future<Cart> fetchCart(String uid);

  Stream<Cart> watchCart(String uid);

  Future<void> setCart(String uid, Cart cart);
}

// TODO: replace with "real" remote cart repository
final remoteCartRepositoryProvider = Provider<RemoteCartRepository>((ref) => FakeRemoteCartRepository());

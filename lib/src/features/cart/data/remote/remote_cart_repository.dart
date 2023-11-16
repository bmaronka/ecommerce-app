import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_cart_repository.g.dart';

// TODO: Implement with Firebase
abstract class RemoteCartRepository {
  Future<Cart> fetchCart(UserID uid);

  Stream<Cart> watchCart(UserID uid);

  Future<void> setCart(UserID uid, Cart cart);
}

@Riverpod(keepAlive: true)
RemoteCartRepository remoteCartRepository(RemoteCartRepositoryRef ref) {
  // TODO: create and return repository
  throw UnimplementedError();
}

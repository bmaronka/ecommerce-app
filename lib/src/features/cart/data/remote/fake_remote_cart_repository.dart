import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeRemoteCartRepository implements RemoteCartRepository {
  FakeRemoteCartRepository({this.addDelay = true});

  final bool addDelay;

  final _carts = InMemoryStore<Map<UserID, Cart>>({});

  @override
  Future<Cart> fetchCart(UserID uid) => Future.value(_carts.value[uid] ?? const Cart());

  @override
  Stream<Cart> watchCart(UserID uid) => _carts.stream.map((cartData) => cartData[uid] ?? const Cart());

  @override
  Future<void> setCart(UserID uid, Cart cart) async {
    await delay(addDelay);
    final carts = _carts.value;
    carts[uid] = cart;
    _carts.value = carts;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_cart_repository.g.dart';

class RemoteCartRepository {
  const RemoteCartRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<Cart> fetchCart(UserID uid) => _cartRef(uid).get().then((cart) => cart.data() ?? const Cart());

  Stream<Cart> watchCart(UserID uid) => _cartRef(uid).snapshots().map((cart) => cart.data() ?? const Cart());

  Future<void> setCart(UserID uid, Cart cart) => _cartRef(uid).set(cart);

  DocumentReference<Cart> _cartRef(UserID uid) => _firestore.doc('cart/$uid').withConverter(
        fromFirestore: (doc, _) => Cart.fromMap(doc.data()!),
        toFirestore: (cart, _) => cart.toMap(),
      );
}

@Riverpod(keepAlive: true)
RemoteCartRepository remoteCartRepository(RemoteCartRepositoryRef ref) =>
    RemoteCartRepository(FirebaseFirestore.instance);

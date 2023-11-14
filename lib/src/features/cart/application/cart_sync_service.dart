import 'dart:math';

import 'package:collection/collection.dart';
import 'package:ecommerce_app/src/exceptions/error_logger.dart';
import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_sync_service.g.dart';

class CartSyncService {
  CartSyncService(this.ref) {
    _init();
  }

  final Ref ref;

  void _init() => ref.listen<AsyncValue<AppUser?>>(
        authStateChangesProvider,
        (previous, next) {
          final previousUser = previous?.value;
          final user = next.value;

          if (previousUser == null && user != null) {
            _moveItemsToRemoteCart(user.uid);
          }
        },
      );

  Future<void> _moveItemsToRemoteCart(String uid) async {
    try {
      final localCartRepository = ref.read(localCartRepositoryProvider);
      final localCart = await localCartRepository.fetchCart();

      if (localCart.items.isNotEmpty) {
        final remoteCartRepository = ref.read(remoteCartRepositoryProvider);
        final remoteCart = await remoteCartRepository.fetchCart(uid);
        final localItemsToAdd = await _getLocalItemsToAdd(localCart, remoteCart);
        final updatedRemoteCart = remoteCart.addItems(localItemsToAdd);

        await remoteCartRepository.setCart(uid, updatedRemoteCart);
        await localCartRepository.setCart(const Cart());
      }
    } catch (error, stackTrace) {
      ref.read(errorLoggerProvider).logError(error, stackTrace);
    }
  }

  Future<List<Item>> _getLocalItemsToAdd(Cart localCart, Cart remoteCart) async {
    final productsRepository = ref.read(productsRepositoryProvider);
    final products = await productsRepository.fetchProductList();
    final localItemsToAdd = <Item>[];

    for (final localItem in localCart.items.entries) {
      final productId = localItem.key;
      final localQuantity = localItem.value;
      final remoteQuantity = remoteCart.items[productId] ?? 0;
      final product = products.firstWhereOrNull((product) => product.id == productId);

      if (product != null) {
        final cappedLocalQuantity = min(localQuantity, product.availableQuantity - remoteQuantity);

        if (cappedLocalQuantity > 0) {
          localItemsToAdd.add(
            Item(
              productId: productId,
              quantity: cappedLocalQuantity,
            ),
          );
        }
      }
    }

    return localItemsToAdd;
  }
}

@Riverpod(keepAlive: true)
CartSyncService cartSyncService(CartSyncServiceRef ref) => CartSyncService(ref);

import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(ordersRepositoryProvider).watchUserOrders(user.uid);
  }

  return const Stream.empty();
});

final matchingUserOrdersProvider = StreamProvider.autoDispose.family<List<Order>, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(ordersRepositoryProvider).watchUserOrders(user.uid, productId: productId);
  } else {
    return Stream.value([]);
  }
});

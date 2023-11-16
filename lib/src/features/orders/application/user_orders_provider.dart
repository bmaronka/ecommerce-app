import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_orders_provider.g.dart';

@riverpod
Stream<List<Order>> userOrders(UserOrdersRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(ordersRepositoryProvider).watchUserOrders(user.uid);
  }

  return const Stream.empty();
}

@riverpod
Stream<List<Order>> matchingUserOrders(MatchingUserOrdersRef ref, ProductID productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(ordersRepositoryProvider).watchUserOrders(user.uid, productId: productId);
  } else {
    return Stream.value([]);
  }
}

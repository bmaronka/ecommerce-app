import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    return ordersRepository.watchUserOrders(user.uid);
  }

  return const Stream.empty();
});

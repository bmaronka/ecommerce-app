import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeOrdersRepository {
  FakeOrdersRepository({this.addDelay = true});
  final bool addDelay;

  final _orders = InMemoryStore<Map<String, List<Order>>>({});

  Stream<List<Order>> watchUserOrders(String uid) => _orders.stream.map((ordersData) {
        final ordersList = ordersData[uid] ?? [];
        ordersList.sort(
          (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
        );
        return ordersList;
      });

  Future<void> addOrder(String uid, Order order) async {
    await delay(addDelay);
    final value = _orders.value;
    final userOrders = value[uid] ?? [];
    userOrders.add(order);
    value[uid] = userOrders;
    _orders.value = value;
  }
}

final ordersRepositoryProvider = Provider<FakeOrdersRepository>((ref) => FakeOrdersRepository());

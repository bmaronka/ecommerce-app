import 'package:ecommerce_app/src/features/orders/data/orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeOrdersRepository implements OrdersRepository {
  FakeOrdersRepository({this.addDelay = true});

  final bool addDelay;

  final _orders = InMemoryStore<Map<String, List<Order>>>({});

  @override
  Stream<List<Order>> watchUserOrders(String uid, {ProductID? productId}) => _orders.stream.map((ordersData) {
        final ordersList = ordersData[uid] ?? [];
        ordersList.sort(
          (lhs, rhs) => rhs.orderDate.compareTo(lhs.orderDate),
        );

        if (productId != null) {
          return ordersList.where((order) => order.items.keys.contains(productId)).toList();
        }

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

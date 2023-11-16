// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus { confirmed, shipped, delivered }

extension OrderStatusString on OrderStatus {
  static OrderStatus fromString(String string) {
    if (string == 'confirmed') return OrderStatus.confirmed;
    if (string == 'shipped') return OrderStatus.shipped;
    if (string == 'delivered') return OrderStatus.delivered;
    throw Exception('Could not parse order status: $string'.hardcoded);
  }
}

typedef OrderID = String;

class Order extends Equatable {
  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.orderStatus,
    required this.orderDate,
    required this.total,
  });

  final OrderID id;
  final String userId;
  final Map<String, int> items;
  final OrderStatus orderStatus;
  final DateTime orderDate;
  final double total;

  @override
  String toString() =>
      'Order(id: $id, userId: $userId, items: $items, orderStatus: $orderStatus, orderDate: $orderDate, total: $total)';

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        orderStatus,
        orderDate,
        total,
      ];
}

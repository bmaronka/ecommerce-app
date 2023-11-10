// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter/foundation.dart';

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

class Order {
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
  bool operator ==(covariant Order other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.userId == userId &&
        mapEquals(other.items, items) &&
        other.orderStatus == orderStatus &&
        other.orderDate == orderDate &&
        other.total == total;
  }

  @override
  int get hashCode =>
      id.hashCode ^ userId.hashCode ^ items.hashCode ^ orderStatus.hashCode ^ orderDate.hashCode ^ total.hashCode;
}

import 'dart:convert';

import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:equatable/equatable.dart';

class Cart extends Equatable {
  const Cart([this.items = const {}]);

  final Map<ProductID, int> items;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'items': items,
      };

  factory Cart.fromMap(Map<String, dynamic> map) => Cart(
        Map<ProductID, int>.from(map['items'] as Map<ProductID, dynamic>),
      );

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Cart(items: $items)';

  @override
  List<Object?> get props => [
        items,
      ];
}

extension CartItems on Cart {
  List<Item> toItemsList() => items.entries
      .map(
        (entry) => Item(
          productId: entry.key,
          quantity: entry.value,
        ),
      )
      .toList();
}

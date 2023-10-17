import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';

class Cart {
  const Cart([this.items = const {}]);

  final Map<ProductID, int> items;
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

import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:equatable/equatable.dart';

class Item extends Equatable {
  const Item({
    required this.productId,
    required this.quantity,
  });

  final ProductID productId;
  final int quantity;

  @override
  String toString() => 'Item(productId: $productId, quantity: $quantity)';

  @override
  List<Object?> get props => [
        productId,
        quantity,
      ];
}

import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final testProduct = Product(
    id: '1',
    imageUrl: 'assets/products/bruschetta-plate.jpg',
    title: 'Bruschetta plate',
    description: 'Lorem ipsum',
    price: 15,
    availableQuantity: 5,
    avgRating: 0.0,
    numRatings: 0,
  );
  final testProductMap = {
    'id': '1',
    'imageUrl': 'assets/products/bruschetta-plate.jpg',
    'title': 'Bruschetta plate',
    'description': 'Lorem ipsum',
    'price': 15,
    'availableQuantity': 5,
    'avgRating': 0.0,
    'numRatings': 0,
  };

  test(
    'fromMap',
    () {
      expect(Product.fromMap(testProductMap), testProduct);
    },
  );

  test(
    'toMap',
    () {
      expect(testProduct.toMap(), testProductMap);
    },
  );
}

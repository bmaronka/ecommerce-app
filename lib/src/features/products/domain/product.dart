// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

typedef ProductID = String;

class Product extends Equatable {
  const Product({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.availableQuantity,
    this.avgRating = 0,
    this.numRatings = 0,
  });

  final ProductID id;
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final int availableQuantity;
  final double avgRating;
  final int numRatings;

  @override
  String toString() =>
      'Product(id: $id, imageUrl: $imageUrl, title: $title, description: $description, price: $price, availableQuantity: $availableQuantity, avgRating: $avgRating, numRatings: $numRatings)';

  @override
  List<Object?> get props => [
        id,
        imageUrl,
        title,
        description,
        price,
        availableQuantity,
        avgRating,
        numRatings,
      ];

  Product copyWith({
    ProductID? id,
    String? imageUrl,
    String? title,
    String? description,
    double? price,
    int? availableQuantity,
    double? avgRating,
    int? numRatings,
  }) =>
      Product(
        id: id ?? this.id,
        imageUrl: imageUrl ?? this.imageUrl,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        availableQuantity: availableQuantity ?? this.availableQuantity,
        avgRating: avgRating ?? this.avgRating,
        numRatings: numRatings ?? this.numRatings,
      );
}

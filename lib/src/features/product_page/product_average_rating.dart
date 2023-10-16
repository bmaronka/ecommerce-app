import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/models/product.dart';
import 'package:flutter/material.dart';

class ProductAverageRating extends StatelessWidget {
  const ProductAverageRating({
    required this.product,
    super.key,
  });

  final Product product;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          gapW8,
          Text(
            product.avgRating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          gapW8,
          Text(
            product.numRatings == 1 ? '1 rating' : '${product.numRatings} ratings',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
}

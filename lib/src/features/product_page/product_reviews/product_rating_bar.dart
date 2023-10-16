import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductRatingBar extends StatelessWidget {
  const ProductRatingBar({
    required this.onRatingUpdate,
    this.initialRating = 0.0,
    this.itemSize = 40,
    this.ignoreGestures = false,
    super.key,
  });

  final double initialRating;
  final double itemSize;
  final bool ignoreGestures;
  final ValueChanged<double> onRatingUpdate;

  @override
  Widget build(BuildContext context) => RatingBar.builder(
        initialRating: initialRating,
        ignoreGestures: ignoreGestures,
        glow: false,
        allowHalfRating: true,
        itemSize: itemSize,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          key: Key('stars-$index'),
          color: Colors.amber,
        ),
        onRatingUpdate: onRatingUpdate,
      );
}

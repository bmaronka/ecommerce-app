import 'package:ecommerce_app/src/common_widgets/responsive_center.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/constants/breakpoints.dart';
import 'package:ecommerce_app/src/features/product_page/product_reviews/product_review_card.dart';
import 'package:ecommerce_app/src/models/review.dart';
import 'package:flutter/material.dart';

final reviews = <Review>[
  Review(
    date: DateTime(2022, 2, 12),
    score: 4.5,
    comment: 'Great product, would buy again!',
  ),
  Review(
    date: DateTime(2022, 2, 10),
    score: 4.0,
    comment: 'Looks great but the packaging was damaged.',
  ),
];

class ProductReviewsList extends StatelessWidget {
  const ProductReviewsList({
    required this.productId,
    super.key,
  });

  final String productId;

  // TODO: Read from data source
  @override
  Widget build(BuildContext context) => SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) => ResponsiveCenter(
            maxContentWidth: Breakpoint.tablet,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p8),
            child: ProductReviewCard(reviews[index]),
          ),
          childCount: reviews.length,
        ),
      );
}

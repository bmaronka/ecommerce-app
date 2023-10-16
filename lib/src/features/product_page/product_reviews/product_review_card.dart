import 'package:ecommerce_app/src/common_widgets/alert_dialogs.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/product_page/product_reviews/product_rating_bar.dart';
import 'package:ecommerce_app/src/models/review.dart';
import 'package:ecommerce_app/src/utils/date_formatter.dart';
import 'package:flutter/material.dart';

class ProductReviewCard extends StatelessWidget {
  const ProductReviewCard(
    this.review, {
    super.key,
  });

  final Review review;

  // TODO: Inject date formatter
  @override
  Widget build(BuildContext context) {
    final dateFormatted = kDateFormatter.format(review.date);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProductRatingBar(
                  initialRating: review.score,
                  ignoreGestures: true,
                  itemSize: 20,
                  onRatingUpdate: (value) =>
                      showNotImplementedAlertDialog(context: context), // TODO: Implement onRatingUpdate
                ),
                Text(
                  dateFormatted,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              gapH16,
              Text(
                review.comment,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

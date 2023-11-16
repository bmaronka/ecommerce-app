import 'dart:async';

import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';

class FakeReviewsService implements ReviewsService {
  const FakeReviewsService({
    required this.fakeAuthRepository,
    required this.fakeReviewsRepository,
    required this.fakeProductsRepository,
  });

  final AuthRepository fakeAuthRepository;
  final ReviewsRepository fakeReviewsRepository;
  final FakeProductsRepository fakeProductsRepository;

  Future<void> submitReview({
    required ProductID productId,
    required Review review,
  }) async {
    final user = fakeAuthRepository.currentUser;

    assert(user != null);
    if (user == null) {
      throw AssertionError('Can\'t submit a review if the user is not signed in'.hardcoded);
    }

    await fakeReviewsRepository.setReview(
      productId: productId,
      uid: user.uid,
      review: review,
    );
    unawaited(_updateProductRating(productId));
  }

  Future<void> _updateProductRating(ProductID productId) async {
    final reviews = await fakeReviewsRepository.fetchReviews(productId);
    final avgRating = _avgReviewScore(reviews);
    final product = fakeProductsRepository.getProduct(productId);

    if (product == null) {
      throw StateError('Product not found with id: $productId.'.hardcoded);
    }

    final updated = product.copyWith(
      avgRating: avgRating,
      numRatings: reviews.length,
    );

    await fakeProductsRepository.setProduct(updated);
  }

  double _avgReviewScore(List<Review> reviews) {
    if (reviews.isNotEmpty) {
      double total = 0.0;

      for (final review in reviews) {
        total += review.rating;
      }

      return total / reviews.length;
    }

    return 0.0;
  }
}

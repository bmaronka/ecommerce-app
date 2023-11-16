import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reviews_repository.g.dart';

// TODO: Implement with Firebase
abstract class ReviewsRepository {
  Stream<Review?> watchUserReview(ProductID id, UserID uid);

  Future<Review?> fetchUserReview(ProductID id, UserID uid);

  Stream<List<Review>> watchReviews(ProductID id);

  Future<List<Review>> fetchReviews(ProductID id);

  Future<void> setReview({
    required ProductID productId,
    required UserID uid,
    required Review review,
  });
}

@Riverpod(keepAlive: true)
ReviewsRepository reviewsRepository(ReviewsRepositoryRef ref) {
  // TODO: create and return repository
  throw UnimplementedError();
}

@riverpod
Stream<List<Review>> productReviews(
  ProductReviewsRef ref,
  ProductID productId,
) =>
    ref.watch(reviewsRepositoryProvider).watchReviews(productId);

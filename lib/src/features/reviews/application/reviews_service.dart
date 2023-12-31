import 'package:ecommerce_app/src/features/authantication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/data/reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reviews_service.g.dart';

// TODO: Implement with Firebase
abstract class ReviewsService {
  Future<void> submitReview({
    required ProductID productId,
    required Review review,
  });
}

@riverpod
ReviewsService reviewsService(ReviewsServiceRef ref) {
  // TODO: create and return service
  throw UnimplementedError();
}

@riverpod
Future<Review?> userReviewFuture(UserReviewFutureRef ref, ProductID productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(reviewsRepositoryProvider).fetchUserReview(productId, user.uid);
  } else {
    return Future.value(null);
  }
}

@riverpod
Stream<Review?> userReviewStream(UserReviewStreamRef ref, ProductID productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(reviewsRepositoryProvider).watchUserReview(productId, user.uid);
  } else {
    return Stream.value(null);
  }
}

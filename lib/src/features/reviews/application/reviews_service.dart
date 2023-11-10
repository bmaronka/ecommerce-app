import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReviewsService {
  const ReviewsService({
    required this.fakeAuthRepository,
    required this.fakeReviewsRepository,
  });

  final FakeAuthRepository fakeAuthRepository;
  final FakeReviewsRepository fakeReviewsRepository;

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
  }
}

final reviewsServiceProvider = Provider<ReviewsService>(
  (ref) => ReviewsService(
    fakeAuthRepository: ref.watch(authRepositoryProvider),
    fakeReviewsRepository: ref.watch(reviewsRepositoryProvider),
  ),
);

final userReviewFutureProvider = FutureProvider.autoDispose.family<Review?, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(reviewsRepositoryProvider).fetchUserReview(productId, user.uid);
  } else {
    return Future.value(null);
  }
});

final userReviewStreamProvider = StreamProvider.autoDispose.family<Review?, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.watch(reviewsRepositoryProvider).watchUserReview(productId, user.uid);
  } else {
    return Stream.value(null);
  }
});

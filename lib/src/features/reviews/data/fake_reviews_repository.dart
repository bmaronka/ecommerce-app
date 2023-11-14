import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_reviews_repository.g.dart';

class FakeReviewsRepository {
  FakeReviewsRepository({this.addDelay = true});
  final bool addDelay;

  final _reviews = InMemoryStore<Map<ProductID, Map<String, Review>>>({});

  Stream<Review?> watchUserReview(ProductID id, String uid) =>
      _reviews.stream.map((reviewsData) => reviewsData[id]?[uid]);

  Future<Review?> fetchUserReview(ProductID id, String uid) async {
    await delay(addDelay);
    return Future.value(_reviews.value[id]?[uid]);
  }

  Stream<List<Review>> watchReviews(ProductID id) => _reviews.stream.map((reviewsData) {
        final reviews = reviewsData[id];
        if (reviews == null) {
          return [];
        } else {
          return reviews.values.toList();
        }
      });

  Future<List<Review>> fetchReviews(ProductID id) async {
    final reviews = _reviews.value[id];
    if (reviews == null) {
      return Future.value([]);
    } else {
      return Future.value(reviews.values.toList());
    }
  }

  Future<void> setReview({
    required ProductID productId,
    required String uid,
    required Review review,
  }) async {
    await delay(addDelay);
    final allReviews = _reviews.value;
    final reviews = allReviews[productId];
    if (reviews != null) {
      reviews[uid] = review;
    } else {
      allReviews[productId] = {uid: review};
    }
    _reviews.value = allReviews;
  }
}

@Riverpod(keepAlive: true)
FakeReviewsRepository reviewsRepository(ReviewsRepositoryRef ref) => FakeReviewsRepository();

@riverpod
Stream<List<Review>> productReviews(ProductReviewsRef ref, ProductID productId) =>
    ref.watch(reviewsRepositoryProvider).watchReviews(productId);

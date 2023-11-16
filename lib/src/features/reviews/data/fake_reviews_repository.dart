import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/data/reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeReviewsRepository implements ReviewsRepository {
  FakeReviewsRepository({this.addDelay = true});

  final bool addDelay;

  final _reviews = InMemoryStore<Map<ProductID, Map<String, Review>>>({});

  @override
  Stream<Review?> watchUserReview(ProductID id, String uid) =>
      _reviews.stream.map((reviewsData) => reviewsData[id]?[uid]);

  @override
  Future<Review?> fetchUserReview(ProductID id, String uid) async {
    await delay(addDelay);
    return Future.value(_reviews.value[id]?[uid]);
  }

  @override
  Stream<List<Review>> watchReviews(ProductID id) => _reviews.stream.map((reviewsData) {
        final reviews = reviewsData[id];
        if (reviews == null) {
          return [];
        } else {
          return reviews.values.toList();
        }
      });

  @override
  Future<List<Review>> fetchReviews(ProductID id) async {
    final reviews = _reviews.value[id];
    if (reviews == null) {
      return Future.value([]);
    } else {
      return Future.value(reviews.values.toList());
    }
  }

  @override
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

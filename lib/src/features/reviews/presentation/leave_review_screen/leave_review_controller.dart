import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'leave_review_controller.g.dart';

@riverpod
class LeaveReviewController extends _$LeaveReviewController {
  final initial = Object();
  late var current = initial;
  // An [Object] instance is equal to itself only.
  bool get mounted => current == initial;

  @override
  FutureOr<void> build() {
    ref.onDispose(() => current = Object());
  }

  Future<void> submitReview({
    Review? previousReview,
    required ProductID productId,
    required double rating,
    required String comment,
    required void Function() onSuccess,
  }) async {
    if (rating == previousReview?.rating && comment == previousReview?.comment) {
      onSuccess();
      return;
    }

    state = const AsyncLoading();
    final review = Review(
      rating: rating,
      comment: comment,
      date: ref.read(currentDateBuilderProvider).call(),
    );
    final newState = await AsyncValue.guard(
      () => ref.read(reviewsServiceProvider).submitReview(productId: productId, review: review),
    );

    if (mounted) {
      state = newState;

      if (state.hasError == false) {
        onSuccess();
      }
    }
  }
}

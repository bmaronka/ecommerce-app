import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late ReviewsService reviewsService;
  late LeaveReviewController leaveReviewController;

  final exception = Exception('Connection failure');
  final testDate = DateTime(2022, 7, 13);
  final testReview = Review(
    rating: 1.0,
    comment: 'test',
    date: testDate,
  );

  setUp(() {
    reviewsService = MockReviewsService();
    leaveReviewController = LeaveReviewController(
      reviewsService: reviewsService,
      currentDateBuilder: () => testDate,
    );
  });

  test(
    'initial state is AsyncData(null)',
    () {
      expect(leaveReviewController.state, AsyncData<void>(null));
    },
  );

  test(
    'success',
    () async {
      when(reviewsService.submitReview(productId: '1', review: testReview)).thenAnswer((_) => Future.value());

      bool didSucceed = false;

      expect(
        leaveReviewController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          const AsyncData<void>(null),
        ]),
      );

      await leaveReviewController.submitReview(
        previousReview: null,
        productId: '1',
        rating: 1.0,
        comment: 'test',
        onSuccess: () => didSucceed = true,
      );

      verify(reviewsService.submitReview(productId: '1', review: testReview)).called(1);
      expect(didSucceed, true);
    },
  );

  test(
    'failure',
    () async {
      when(reviewsService.submitReview(productId: '1', review: testReview)).thenThrow(exception);

      bool didSucceed = false;

      expect(
        leaveReviewController.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );

      await leaveReviewController.submitReview(
        previousReview: null,
        productId: '1',
        rating: 1.0,
        comment: 'test',
        onSuccess: () => didSucceed = true,
      );

      verify(reviewsService.submitReview(productId: '1', review: testReview)).called(1);
      expect(didSucceed, false);
    },
  );

  test(
    'same data as before',
    () async {
      bool didSucceed = false;

      expect(
        leaveReviewController.stream,
        emitsInOrder([]),
      );

      await leaveReviewController.submitReview(
        previousReview: testReview,
        productId: '1',
        rating: 1.0,
        comment: 'test',
        onSuccess: () => didSucceed = true,
      );

      verifyNever(reviewsService.submitReview(productId: '1', review: testReview));
      expect(didSucceed, true);
    },
  );
}

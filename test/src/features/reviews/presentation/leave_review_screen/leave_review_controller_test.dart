import 'package:ecommerce_app/src/features/reviews/application/fake_reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_controller.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.dart';
import '../../../../mocks.mocks.dart';

void main() {
  late MockFakeReviewsService reviewsService;

  final testDate = DateTime(2022, 7, 31);
  const testRating = 5.0;
  const testComment = 'love it!';
  final testReview = Review(
    rating: testRating,
    comment: testComment,
    date: testDate,
  );
  const testProductId = '1';
  final exception = Exception('Connection failure');

  setUp(() => reviewsService = MockFakeReviewsService());

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        reviewsServiceProvider.overrideWithValue(reviewsService),
        currentDateBuilderProvider.overrideWithValue(() => testDate),
      ],
    );
    addTearDown(container.dispose);

    return container;
  }

  group(
    'submitReview',
    () {
      test(
        'success',
        () async {
          when(reviewsService.submitReview(productId: testProductId, review: testReview))
              .thenAnswer((_) => Future.value());
          final container = makeProviderContainer();
          final controller = container.read(leaveReviewControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            leaveReviewControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          var didSucceed = false;
          await controller.submitReview(
            previousReview: null,
            rating: testRating,
            comment: testComment,
            productId: testProductId,
            onSuccess: () => didSucceed = true,
          );

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), data),
          ]);
          verifyNoMoreInteractions(listener);
          verify(reviewsService.submitReview(productId: testProductId, review: testReview)).called(1);
          expect(didSucceed, true);
        },
      );

      test(
        'failure',
        () async {
          when(reviewsService.submitReview(productId: testProductId, review: testReview)).thenThrow(exception);
          final container = makeProviderContainer();
          final controller = container.read(leaveReviewControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            leaveReviewControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          var didSucceed = false;
          await controller.submitReview(
            previousReview: null,
            rating: testRating,
            comment: testComment,
            productId: testProductId,
            onSuccess: () => didSucceed = true,
          );

          verifyInOrder([
            listener(data, argThat(isA<AsyncLoading>())),
            listener(argThat(isA<AsyncLoading>()), argThat(isA<AsyncError>())),
          ]);
          verifyNoMoreInteractions(listener);
          verify(reviewsService.submitReview(productId: testProductId, review: testReview)).called(1);
          expect(didSucceed, false);
        },
      );

      test(
        'same data as before',
        () async {
          when(reviewsService.submitReview(productId: testProductId, review: testReview)).thenThrow(exception);
          final container = makeProviderContainer();
          final controller = container.read(leaveReviewControllerProvider.notifier);
          final listener = Listener();
          container.listen(
            leaveReviewControllerProvider,
            listener,
            fireImmediately: true,
          );

          const data = AsyncData<void>(null);
          verify(listener(null, data));

          var didSucceed = false;
          await controller.submitReview(
            previousReview: testReview,
            rating: testRating,
            comment: testComment,
            productId: testProductId,
            onSuccess: () => didSucceed = true,
          );

          verifyNoMoreInteractions(listener);
          verifyNever(reviewsService.submitReview(productId: testProductId, review: testReview));
          expect(didSucceed, true);
        },
      );
    },
  );
}

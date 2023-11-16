import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/application/fake_reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository fakeAuthRepository;
  late FakeReviewsRepository fakeReviewsRepository;
  late FakeProductsRepository fakeProductsRepository;

  late ReviewsService reviewsService;

  const testUser = AppUser(uid: 'abc');
  final testDate = DateTime(2022, 7, 13);
  final testReview = Review(
    rating: 1.0,
    comment: 'test',
    date: testDate,
  );
  final testProduct = Product(
    id: '1',
    imageUrl: 'assets/products/bruschetta-plate.jpg',
    title: 'Bruschetta plate',
    description: 'Lorem ipsum',
    price: 15,
    availableQuantity: 5,
  );

  setUp(() {
    fakeAuthRepository = MockFakeAuthRepository();
    fakeReviewsRepository = MockFakeReviewsRepository();
    fakeProductsRepository = MockFakeProductsRepository();

    reviewsService = FakeReviewsService(
      fakeAuthRepository: fakeAuthRepository,
      fakeReviewsRepository: fakeReviewsRepository,
      fakeProductsRepository: fakeProductsRepository,
    );
  });

  test(
    'submit review for non-null user',
    () async {
      when(fakeAuthRepository.currentUser).thenReturn(testUser);
      when(fakeReviewsRepository.setReview(productId: '1', uid: testUser.uid, review: testReview))
          .thenAnswer((_) => Future.value());
      when(fakeReviewsRepository.fetchReviews('1')).thenAnswer((_) => Future.value([testReview]));
      when(fakeProductsRepository.getProduct('1')).thenAnswer((_) => testProduct);

      await reviewsService.submitReview(productId: '1', review: testReview);

      verify(fakeAuthRepository.currentUser).called(1);
      verify(fakeReviewsRepository.setReview(productId: '1', uid: testUser.uid, review: testReview)).called(1);
    },
  );

  test(
    'submit review for null user',
    () async {
      when(fakeAuthRepository.currentUser).thenReturn(null);

      expect(reviewsService.submitReview(productId: '1', review: testReview), throwsAssertionError);
    },
  );
}

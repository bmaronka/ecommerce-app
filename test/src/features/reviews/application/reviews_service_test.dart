import 'package:ecommerce_app/src/features/authantication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authantication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/application/fake_reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks.mocks.dart';

void main() {
  late FakeAuthRepository authRepository;
  late FakeReviewsRepository reviewsRepository;
  late FakeProductsRepository productsRepository;

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
    authRepository = MockFakeAuthRepository();
    reviewsRepository = MockFakeReviewsRepository();
    productsRepository = MockFakeProductsRepository();
  });

  FakeReviewsService makeCheckoutService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
      ],
    );
    addTearDown(container.dispose);

    return container.read(reviewsServiceProvider);
  }

  test(
    'submit review for non-null user',
    () async {
      when(authRepository.currentUser).thenReturn(testUser);
      when(reviewsRepository.setReview(productId: '1', uid: testUser.uid, review: testReview))
          .thenAnswer((_) => Future.value());
      when(reviewsRepository.fetchReviews('1')).thenAnswer((_) => Future.value([testReview]));
      when(productsRepository.getProduct('1')).thenAnswer((_) => testProduct);
      final service = makeCheckoutService();

      await service.submitReview(productId: '1', review: testReview);

      verify(authRepository.currentUser).called(1);
      verify(reviewsRepository.setReview(productId: '1', uid: testUser.uid, review: testReview)).called(1);
    },
  );

  test(
    'submit review for null user',
    () async {
      when(authRepository.currentUser).thenReturn(null);
      final service = makeCheckoutService();

      expect(service.submitReview(productId: '1', review: testReview), throwsAssertionError);
    },
  );
}

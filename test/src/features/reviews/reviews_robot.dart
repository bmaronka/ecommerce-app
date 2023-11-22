import 'package:ecommerce_app/src/features/reviews/presentation/leave_review_screen/leave_review_screen.dart';
import 'package:ecommerce_app/src/features/reviews/presentation/product_reviews/product_review_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class ReviewsRobot {
  const ReviewsRobot(this.tester);

  final WidgetTester tester;

  void expectFindLeaveReview() {
    final finder = find.text('Leave a review');
    expect(finder, findsOneWidget);
  }

  void expectFindUpdateReview() {
    final finder = find.text('Update a review');
    expect(finder, findsOneWidget);
  }

  Future<void> tapLeaveReview() async {
    final finder = find.text('Leave a review');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> tapUpdateReview() async {
    final finder = find.text('Update a review');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> enterReviewRating() async {
    final finder = find.byKey(Key('stars-4'));
    expect(finder, findsOneWidget);
    await tester.tap(finder);
  }

  Future<void> enterReviewComment(String comment) async {
    final finder = find.byKey(LeaveReviewForm.reviewCommentKey);
    expect(finder, findsOneWidget);
    await tester.enterText(finder, comment);
  }

  Future<void> submitReview() async {
    final finder = find.text('Submit');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> createAndSubmitReview(String comment) async {
    await enterReviewRating();
    await enterReviewComment(comment);
    await submitReview();
  }

  void expectOneReviewFound() {
    final finder = find.byType(ProductReviewCard, skipOffstage: false);
    expect(finder, findsOneWidget);
  }

  void expectFindText(String text) {
    final finder = find.text(text);
    expect(finder, findsOneWidget);
  }

  Future<void> scrollToAddedReview(String text) async {
    final finder = find.text(text);
    await tester.scrollUntilVisible(finder, 50);
  }

  Future<void> updateAndSubmitReview(String comment) async {
    await enterReviewComment(comment);
    await submitReview();
  }
}

import 'package:equatable/equatable.dart';

class Review extends Equatable {
  const Review({
    required this.rating,
    required this.comment,
    required this.date,
  });

  final double rating;
  final String comment;
  final DateTime date;

  Review copyWith({
    double? rating,
    String? comment,
    DateTime? date,
  }) =>
      Review(
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        date: date ?? this.date,
      );

  @override
  String toString() => 'Review(rating: $rating, comment: $comment, date: $date)';

  @override
  List<Object?> get props => [
        rating,
        comment,
        date,
      ];
}

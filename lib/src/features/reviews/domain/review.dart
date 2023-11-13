class Review {
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
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.rating == rating && other.comment == comment && other.date == date;
  }

  @override
  int get hashCode => rating.hashCode ^ comment.hashCode ^ date.hashCode;
}

class Review {
  const Review({
    required this.score,
    required this.comment,
    required this.date,
  });

  final double score;
  final String comment;
  final DateTime date;

  Review copyWith({
    double? score,
    String? comment,
    DateTime? date,
  }) =>
      Review(
        score: score ?? this.score,
        comment: comment ?? this.comment,
        date: date ?? this.date,
      );

  @override
  String toString() => 'Review(score: $score, comment: $comment, date: $date)';

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.score == score && other.comment == comment && other.date == date;
  }

  @override
  int get hashCode => score.hashCode ^ comment.hashCode ^ date.hashCode;
}

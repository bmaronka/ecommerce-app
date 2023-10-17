class Review {
  const Review({
    required this.score,
    required this.comment,
    required this.date,
  });

  final double score;
  final String comment;
  final DateTime date;
}

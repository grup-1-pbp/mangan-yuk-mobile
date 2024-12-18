class Review {
  final String id;
  final String userName;
  final String content;
  final int rating;
  final DateTime date;

  Review({
    required this.id,
    required this.userName,
    required this.content,
    required this.rating,
    required this.date,
  });
}
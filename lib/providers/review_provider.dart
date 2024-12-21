import 'package:flutter/material.dart';

class Review {
  final String userName;
  final String content;
  final double rating;

  Review({
    required this.userName,
    required this.content,
    required this.rating,
  });
}

class ReviewProvider with ChangeNotifier {
  final List<Review> _reviews = [];

  List<Review> get reviews => [..._reviews];

  void addReview(String userName, String content, double rating) {
    _reviews.add(Review(userName: userName, content: content, rating: rating));
    notifyListeners(); // Update UI
  }
}

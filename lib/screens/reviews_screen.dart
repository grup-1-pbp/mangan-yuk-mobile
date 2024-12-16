import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';
import 'add_review_screen.dart';

class ReviewsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Expanded(
            child: reviewProvider.reviews.isEmpty
                ? Center(child: Text('No reviews yet. Be the first to review!'))
                : ListView.builder(
                    itemCount: reviewProvider.reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviewProvider.reviews[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text(review.userName[0]), // Initials
                            ),
                            title: Text(review.userName),
                            subtitle: Text(review.content),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(review.rating.toStringAsFixed(1)),
                                Icon(Icons.star, color: Colors.amber),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => AddReviewScreen()),
                );
              },
              child: Text('Write your review here!'),
            ),
          ),
        ],
      ),
    );
  }
}

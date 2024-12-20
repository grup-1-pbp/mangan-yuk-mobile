import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/models/review_entry.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/widgets/left_drawer.dart';
import 'package:mangan_yuk_mobile/screens/reviewentry_form.dart'; // Pastikan ini mengarah ke AddReviewScreen

class ReviewPage extends StatefulWidget {
  final String foodId;
  final String username;

  const ReviewPage({super.key, required this.foodId, required this.username});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  Future<List<Review>> fetchReviews(
      CookieRequest request, String foodId) async {
    try {
      final response = await request
          .get('https://mangan-yuk-production.up.railway.app/review/review-json/$foodId/');
      if (response is! List) {
        return [];
      }

      // Filter reviews based on foodId
      final filteredReviews = response
          .map((data) => Review.fromJson(data))
          .where((review) => review.fields.food == foodId)
          .toList();

      return filteredReviews;
    } catch (e) {
      print('Error fetching reviews: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Entry List'),
        backgroundColor: Colors.teal,
      ),
      drawer: LeftDrawer(
        role: "buyer",
        username: widget.username,
      ),
      body: FutureBuilder(
        future: fetchReviews(request, widget.foodId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada ulasan tersedia.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              final review = snapshot.data[index];
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8.0,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (starIndex) {
                        return Icon(
                          starIndex < review.fields.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      review.fields.comment,
                      style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Created at: ${review.fields.createdAt}",
                      style:
                          const TextStyle(fontSize: 14.0, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Navigasi ke halaman AddReviewScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddReviewScreen(foodId: widget.foodId),
            ),
          ).then((_) {
            // Refresh data setelah kembali dari halaman AddReviewScreen
            setState(() {});
          });
        },
      ),
    );
  }
}

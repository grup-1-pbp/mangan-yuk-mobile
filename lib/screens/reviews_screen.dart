import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';
import 'add_review_screen.dart';

@override
void initState() {
  super.initState();
  Provider.of<ReviewProvider>(context, listen: false)
      .fetchReviews(widget.foodId);
}
class ReviewsScreen extends StatelessWidget {
  // Fungsi untuk menghitung rata-rata rating
  double _calculateAverageRating(List<dynamic> reviews) {
    if (reviews.isEmpty) return 0.0;
    double total = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  // Fungsi untuk mendapatkan warna berdasarkan rating
  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.lightGreen;
    if (rating >= 3.0) return Colors.amber;
    if (rating >= 2.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final reviewProvider = Provider.of<ReviewProvider>(context);
    final averageRating = _calculateAverageRating(reviewProvider.reviews);
    
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        title: Text(
          'Reviews & Ratings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.white70),
            onPressed: () {
              // Implement sorting functionality
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Section
          if (reviewProvider.reviews.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    title: 'Average Rating',
                    value: averageRating.toStringAsFixed(1),
                    icon: Icons.star,
                    iconColor: _getRatingColor(averageRating),
                    showStars: true,
                    rating: averageRating,
                  ),
                  Container(height: 40, width: 1, color: Colors.grey[700]),
                  _buildStatItem(
                    title: 'Total Reviews',
                    value: '${reviewProvider.reviews.length}',
                    icon: Icons.rate_review,
                    iconColor: Colors.blue,
                    showStars: false,
                    rating: 0,
                  ),
                ],
              ),
            ),
          
          Expanded(
            child: reviewProvider.reviews.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 80,
                          color: Colors.grey[700],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No reviews yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Be the first to share your experience!',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: reviewProvider.reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviewProvider.reviews[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.purple, Colors.red],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        review.userName[0].toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          review.userName,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            ...List.generate(5, (index) {
                                              return Icon(
                                                index < review.rating.floor()
                                                    ? Icons.star
                                                    : Icons.star_border,
                                                color: _getRatingColor(review.rating),
                                                size: 18,
                                              );
                                            }),
                                            SizedBox(width: 8),
                                            Text(
                                              review.rating.toStringAsFixed(1),
                                              style: TextStyle(
                                                color: _getRatingColor(review.rating),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                review.content,
                                style: TextStyle(
                                  color: Colors.grey[300],
                                  fontSize: 16,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => AddReviewScreen()),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.edit, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Write a Review',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool showStars,
    required double rating,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: 24),
        SizedBox(height: 8),
        if (showStars) Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.star, color: iconColor, size: 16),
          ],
        ) else Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
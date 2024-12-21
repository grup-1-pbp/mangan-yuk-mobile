import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'dart:convert'; // Untuk jsonEncode

class AddReviewScreen extends StatefulWidget {
  final String foodId; // ID makanan untuk mengaitkan review

  const AddReviewScreen({super.key, required this.foodId});

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _contentController = TextEditingController(); // Controller untuk isi review
  double _rating = 3.0; // Default rating

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>(); // Untuk mengirim data ke backend

    return Scaffold(
      appBar: AppBar(
        title: const Text('Write a Review'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Rate your experience',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0; // Update rating
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () async {
                if (_contentController.text.isNotEmpty) {
                  try {
                    final response = await request.postJson(
                      'https://mangan-yuk-production.up.railway.app/review/add-review/${widget.foodId}/', // Endpoint backend
                      jsonEncode({
                        'rating': _rating.toInt(), // Kirim rating
                        'comment': _contentController.text, // Kirim isi review
                      }),
                    );

                    if (response['status'] == 'success') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Review added successfully!')),
                      );
                      Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to add review: ${response['message']}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please write a review before submitting!')),
                  );
                }
              },
              child: const Text('Add Review'),
            ),
          ],
        ),
      ),
    );
  }
}

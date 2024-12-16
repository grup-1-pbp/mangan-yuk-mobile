import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/review_provider.dart';

class AddReviewScreen extends StatefulWidget {
  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _contentController = TextEditingController();
  double _rating = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a Review'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Rate your experience',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
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
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                if (_contentController.text.isNotEmpty) {
                  Provider.of<ReviewProvider>(context, listen: false)
                      .addReview('Anonymous', _contentController.text, _rating);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add Review'),
            ),
          ],
        ),
      ),
    );
  }
}

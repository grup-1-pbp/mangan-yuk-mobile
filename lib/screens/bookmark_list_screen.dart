import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/models/bookmark.dart';

class BookmarkListScreen extends StatelessWidget {
  const BookmarkListScreen({Key? key}) : super(key: key);

  Future<Bookmark> fetchBookmarks() async {
    final response = await http.get(Uri.parse('http://localhost:8000/bookmark/flutter/'));

    if (response.statusCode == 200) {
      return bookmarkFromJson(response.body);
    } else {
      throw Exception('Failed to load bookmarks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark List'),
      ),
      body: FutureBuilder<Bookmark>(
        future: fetchBookmarks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final bookmarks = snapshot.data!.data.likedFood;
            if (bookmarks.isEmpty) {
              return const Center(child: Text('No bookmarks found.'));
            }
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      bookmark.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 50);
                      },
                    ),
                    title: Text(bookmark.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Restaurant: ${bookmark.restaurant}'),
                        Text('Price: ${bookmark.price}'),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Unexpected error occurred.'));
          }
        },
      ),
    );
  }
}

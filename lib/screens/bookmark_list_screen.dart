import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mangan_yuk_mobile/models/bookmark.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class BookmarkListScreen extends StatelessWidget {
  final String username;

  const BookmarkListScreen({super.key, required this.username});

  Future<List<Bookmark>> fetchBookmarks(
      BuildContext context, String username) async {
    print("sadsa ssdasd" + username);
    print("Fetching bookmarks for username: $username"); // Log username
    final response = await Provider.of<CookieRequest>(context, listen: false)
        .get("http://127.0.0.1:8000/bookmark/json/$username/");
    if (response['status'] == 'success' && response['data'] != null) {
      return Bookmark.fromJsonList(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Invalid response format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Saved Foods'),
      ),
      body: FutureBuilder<List<Bookmark>>(
        future: fetchBookmarks(context, username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookmarks found.'));
          } else {
            final bookmarks = snapshot.data!;
            return ListView.builder(
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = bookmarks[index];
                return ListTile(
                  leading: Image.network(bookmark.imageUrl, fit: BoxFit.cover),
                  title: Text(bookmark.name),
                  subtitle: Text(bookmark.restaurant),
                  trailing: Text('Rp ${bookmark.price}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

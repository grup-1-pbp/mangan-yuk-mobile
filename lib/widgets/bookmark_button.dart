import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class BookmarkButton extends StatefulWidget {
  final String foodId;
  final String username; // Tambahkan username sebagai parameter
  final bool isBookmarked;
  final Function(bool) onToggle;

  const BookmarkButton({
    Key? key,
    required this.foodId,
    required this.username,
    required this.isBookmarked,
    required this.onToggle,
  }) : super(key: key);

  @override
  State<BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> {
  late bool _isBookmarked;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
  }

  Future<void> _toggleBookmark(BuildContext context) async {
    final request = Provider.of<CookieRequest>(context, listen: false);

    try {
      final response = await request.get(
        "http://127.0.0.1:8000/bookmark/json/${widget.username}/${widget.foodId}/",
      );

      if (response['liked'] != null) {
        setState(() {
          _isBookmarked = response['liked'];
        });
        widget.onToggle(_isBookmarked);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to toggle bookmark.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: IconButton(
        icon: Icon(
          _isBookmarked ? Icons.favorite : Icons.favorite_border,
          color: _isBookmarked ? Colors.red : Colors.grey,
          size: 35,
        ),
        onPressed: () {
          _toggleBookmark(context);
        },
      ),
    );
  }
}

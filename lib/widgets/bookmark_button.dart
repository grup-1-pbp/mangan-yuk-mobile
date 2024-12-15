import 'package:flutter/material.dart';

class BookmarkButton extends StatefulWidget {
  final String foodId;
  final bool isBookmarked;
  final Function(bool) onToggle;

  const BookmarkButton({
    Key? key,
    required this.foodId,
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
          setState(() {
            _isBookmarked = !_isBookmarked;
            widget.onToggle(_isBookmarked);
          });
        },
      ),
    );
  }
}

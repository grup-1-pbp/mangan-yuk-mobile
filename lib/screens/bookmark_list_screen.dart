import 'package:flutter/material.dart';
import 'package:mangan_yuk_mobile/widgets/bookmark_button.dart';
import 'package:mangan_yuk_mobile/models/bookmark_model.dart';
import 'package:mangan_yuk_mobile/models/food_entry.dart';

class BookmarkListScreen extends StatefulWidget {
  const BookmarkListScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkListScreen> createState() => _BookmarkListScreenState();
}

class _BookmarkListScreenState extends State<BookmarkListScreen> {
  List<FoodEntry> bookmarkedFoods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBookmarks();
  }

  void loadBookmarks() {
    setState(() {
      bookmarkedFoods = BookmarkModel.getBookmarkedFoods();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Saved Foods'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(20),
              itemCount: bookmarkedFoods.length,
              itemBuilder: (context, index) {
                final food = bookmarkedFoods[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            food.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Rp ${food.price}'),
                              Text(food.restaurant),
                              Text(preferenceValues.reverse[food.preference]!),
                            ],
                          ),
                        ),
                        BookmarkButton(
                          foodId: food.id,
                          isBookmarked: food.isBookmarked,
                          onToggle: (isBookmarked) {
                            setState(() {
                              food.isBookmarked = isBookmarked;
                              if (!isBookmarked) {
                                bookmarkedFoods.remove(food);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
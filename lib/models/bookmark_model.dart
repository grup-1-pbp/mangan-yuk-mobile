import 'dart:convert';
import 'package:mangan_yuk_mobile/models/food_entry.dart';
import 'package:mangan_yuk_mobile/screens/artikel_detail_page.dart';

class BookmarkModel {
  String id;
  FoodEntry food;
  bool isBookmarked;
  
  static List<FoodEntry> _bookmarkedFoods = [];

  BookmarkModel({
    required this.id,
    required this.food,
    this.isBookmarked = false,
  });

  // Existing JSON methods
  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
        id: json["id"],
        food: FoodEntry.fromJson(json["food"]),
        isBookmarked: json["is_bookmarked"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "food": food.toJson(),
        "is_bookmarked": isBookmarked,
      };

  // Added BookmarkService methods
  static List<FoodEntry> getBookmarkedFoods() {
    return _bookmarkedFoods;
  }

  static void toggleBookmark(FoodEntry food) {
    if (_bookmarkedFoods.contains(food)) {
      _bookmarkedFoods.remove(food);
    } else {
      _bookmarkedFoods.add(food);
    }
  }
}

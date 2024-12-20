import 'package:shared_preferences/shared_preferences.dart';

class BookmarkStorage {
  static const String key = 'bookmarked_foods';
  
  static Future<List<String>> getBookmarkedIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> saveBookmarkedId(String foodId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarkedIds();
    if (!bookmarks.contains(foodId)) {
      bookmarks.add(foodId);
      await prefs.setStringList(key, bookmarks);
    }
  }

  static Future<void> removeBookmarkedId(String foodId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarkedIds();
    bookmarks.remove(foodId);
    await prefs.setStringList(key, bookmarks);
  }
}
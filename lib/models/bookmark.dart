import 'dart:convert';

import 'package:mangan_yuk_mobile/models/food_entry.dart';

Bookmark bookmarkFromJson(String str) => Bookmark.fromJson(json.decode(str));

String bookmarkToJson(Bookmark data) => json.encode(data.toJson());

class Bookmark {
    String status;
    Data data;
    static List<FoodEntry> _bookmarkedFoods = [];

    Bookmark({
        required this.status,
        required this.data,
    });


    // Added getBookmarkedFoods method
    static List<FoodEntry> getBookmarkedFoods() {
        return _bookmarkedFoods;
    }

    factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
    };

    static List<FoodEntry> get bookmarkedFoods => _bookmarkedFoods;

    static void toggleBookmark(FoodEntry food) {
        if (_bookmarkedFoods.contains(food)) {
            _bookmarkedFoods.remove(food);
        } else {
            _bookmarkedFoods.add(food);
        }
    }
}


class Data {
    List<LikedFood> likedFood;

    Data({
        required this.likedFood,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        likedFood: List<LikedFood>.from(json["liked_food"].map((x) => LikedFood.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "liked_food": List<dynamic>.from(likedFood.map((x) => x.toJson())),
    };
}

class LikedFood {
    String id;
    String name;
    String restaurant;
    String deskripsi;
    String price;
    String preference;
    String imageUrl;

    LikedFood({
        required this.id,
        required this.name,
        required this.restaurant,
        required this.deskripsi,
        required this.price,
        required this.preference,
        required this.imageUrl,
    });

    factory LikedFood.fromJson(Map<String, dynamic> json) => LikedFood(
        id: json["id"],
        name: json["name"],
        restaurant: json["restaurant"],
        deskripsi: json["deskripsi"],
        price: json["price"],
        preference: json["preference"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "restaurant": restaurant,
        "deskripsi": deskripsi,
        "price": price,
        "preference": preference,
        "image_url": imageUrl,
    };
}
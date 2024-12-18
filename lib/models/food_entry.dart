// To parse this JSON data, do
//
//     final FoodEntry = FoodEntryFromJson(jsonString);

import 'dart:convert';

List<FoodEntry> FoodEntryFromJson(String str) => List<FoodEntry>.from(json.decode(str).map((x) => FoodEntry.fromJson(x)));

String FoodEntryToJson(List<FoodEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodEntry {
    String name;
    String id;
    String restaurant;
    String price;
    Preference preference;
    String deskripsi;
    String imageUrl;
    bool isBookmarked; // Add this field

    FoodEntry({
        required this.name,
        required this.id,
        required this.restaurant,
        required this.price,
        required this.preference,
        required this.deskripsi,
        required this.imageUrl,
        this.isBookmarked = false, // Default value
        
    });

    factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        name: json["name"],
        id: json["id"],
        restaurant: json["restaurant"],
        price: json["price"],
        preference: preferenceValues.map[json["preference"]]!,
        deskripsi: json["deskripsi"],
        imageUrl: json["image_url"],
        isBookmarked: json["is_bookmarked"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "restaurant": restaurant,
        "price": price,
        "preference": preferenceValues.reverse[preference],
        "deskripsi": deskripsi,
        "image_url": imageUrl,
        "is_bookmarked": isBookmarked,
    };
}

enum Preference {
    CHIN,
    CHINESE,
    INDIAN,
    INDO,
    INDONESIA,
    JAPANESE,
    JEPANG,
    PREFERENCE_WESTERN,
    WEST,
    WESTERN
}

final preferenceValues = EnumValues({
    "Chin": Preference.CHIN,
    "Chinese": Preference.CHINESE,
    "Indian": Preference.INDIAN,
    "Indo": Preference.INDO,
    "Indonesia": Preference.INDONESIA,
    "Japanese": Preference.JAPANESE,
    "Jepang": Preference.JEPANG,
    "western": Preference.PREFERENCE_WESTERN,
    "West": Preference.WEST,
    "Western": Preference.WESTERN
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
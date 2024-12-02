// To parse this JSON data, do
//
//     final foodEntry = foodEntryFromJson(jsonString);

import 'dart:convert';

List<FoodEntry> foodEntryFromJson(String str) => List<FoodEntry>.from(json.decode(str).map((x) => FoodEntry.fromJson(x)));

String foodEntryToJson(List<FoodEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodEntry {
    Model model;
    String pk;
    Fields fields;

    FoodEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String restaurant;
    String deskripsi;
    String price;
    Preference preference;
    String imageUrl;

    Fields({
        required this.name,
        required this.restaurant,
        required this.deskripsi,
        required this.price,
        required this.preference,
        required this.imageUrl,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        restaurant: json["restaurant"],
        deskripsi: json["deskripsi"],
        price: json["price"],
        preference: preferenceValues.map[json["preference"]]!,
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "restaurant": restaurant,
        "deskripsi": deskripsi,
        "price": price,
        "preference": preferenceValues.reverse[preference],
        "image_url": imageUrl,
    };
}

enum Preference {
    CHINESE,
    INDIAN,
    INDO,
    INDONESIA,
    JAPANESE,
    JEPANG,
    PREFERENCE_WESTERN,
    WESTERN
}

final preferenceValues = EnumValues({
    "Chinese": Preference.CHINESE,
    "Indian": Preference.INDIAN,
    "Indo": Preference.INDO,
    "Indonesia": Preference.INDONESIA,
    "Japanese": Preference.JAPANESE,
    "Jepang": Preference.JEPANG,
    "western": Preference.PREFERENCE_WESTERN,
    "Western": Preference.WESTERN
});

enum Model {
    MAIN_FOOD
}

final modelValues = EnumValues({
    "main.food": Model.MAIN_FOOD
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

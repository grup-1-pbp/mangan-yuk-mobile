// To parse this JSON data, do
//
//     final food = foodFromJson(jsonString);

import 'dart:convert';

List<Food> foodFromJson(String str) => List<Food>.from(json.decode(str).map((x) => Food.fromJson(x)));

String foodToJson(List<Food> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Food {
    String model;
    String pk;
    Fields fields;

    Food({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Food.fromJson(Map<String, dynamic> json) => Food(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String restaurant;
    String description;
    String price;
    String preference;
    String imageUrl;

    Fields({
        required this.name,
        required this.restaurant,
        required this.description,
        required this.price,
        required this.preference,
        required this.imageUrl,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        restaurant: json["restaurant"],
        description: json["description"],
        price: json["price"],
        preference: json["preference"],
        imageUrl: json["image_url"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "restaurant": restaurant,
        "description": description,
        "price": price,
        "preference": preference,
        "image_url": imageUrl,
    };
}

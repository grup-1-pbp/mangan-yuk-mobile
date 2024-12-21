import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    Model model;
    int pk;
    Fields fields;

    Review({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
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
    String food;
    int user;
    int rating;
    String comment;
    DateTime createdAt;

    Fields({
        required this.food,
        required this.user,
        required this.rating,
        required this.comment,
        required this.createdAt,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        food: json["food"],
        user: json["user"],
        rating: json["rating"],
        comment: json["comment"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "food": food,
        "user": user,
        "rating": rating,
        "comment": comment,
        "created_at": createdAt.toIso8601String(),
    };
}

enum Model {
    REVIEW_REVIEW
}

final modelValues = EnumValues({
    "review.review": Model.REVIEW_REVIEW
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
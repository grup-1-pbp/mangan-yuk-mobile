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
        model: json["model"] ?? "", // Berikan nilai default jika null
        pk: json["pk"] ?? "",       // Berikan nilai default jika null
        fields: Fields.fromJson(json["fields"] ?? {}), // Berikan empty map jika null
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
        name: json["name"] ?? "",
        restaurant: json["restaurant"] ?? "",
        description: json["description"] ?? "",
        price: json["price"] ?? "",
        preference: json["preference"] ?? "",
        imageUrl: json["image_url"] ?? "", // Perhatikan ini menggunakan "image_url" bukan "imageUrl"
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "restaurant": restaurant,
        "description": description,
        "price": price,
        "preference": preference,
        "image_url": imageUrl, // Pastikan menggunakan "image_url" saat mengirim ke server
    };
}
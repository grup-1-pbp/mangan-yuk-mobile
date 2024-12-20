import 'dart:convert';

class Bookmark {
  String id;
  String name;
  String restaurant;
  String deskripsi;
  String price;
  String preference;
  String imageUrl;

  Bookmark({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.deskripsi,
    required this.price,
    required this.preference,
    required this.imageUrl,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      name: json['name'],
      restaurant: json['restaurant'],
      deskripsi: json['deskripsi'],
      price: json['price'],
      preference: json['preference'],
      imageUrl: json['image_url'],
    );
  }

  static List<Bookmark> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Bookmark.fromJson(json)).toList();
  }
}

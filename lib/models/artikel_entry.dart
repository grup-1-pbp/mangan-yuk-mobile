// To parse this JSON data, do
//
//     final ArtikelEntry = ArtikelEntryFromJson(jsonString);

import 'dart:convert';

List<ArtikelEntry> artikelEntryFromJson(String str) => List<ArtikelEntry>.from(json.decode(str).map((x) => ArtikelEntry.fromJson(x)));

String ArtikelEntryToJson(List<ArtikelEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArtikelEntry {
    Model model;
    String pk;
    Fields fields;

    ArtikelEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ArtikelEntry.fromJson(Map<String, dynamic> json) => ArtikelEntry(
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
    String judul;
    String isi;
    String gambarUrl;

    Fields({
        required this.judul,
        required this.isi,
        required this.gambarUrl,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        judul: json["judul"],
        isi: json["isi"],
        gambarUrl: json["gambar_url"],
    );

    Map<String, dynamic> toJson() => {
        "judul": judul,
        "isi": isi,
        "gambar_url": gambarUrl,
    };
}




enum Model {
    ARTIKELL_ARTIKEL
}

final modelValues = EnumValues({
    "artikell.artikel": Model.ARTIKELL_ARTIKEL
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

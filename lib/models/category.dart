import 'dart:convert';

class Category {
  int id;
  String namaKategori;
  String slug;
  String? gambar;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    required this.id,
    required this.namaKategori,
    required this.slug,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    this.gambar,
  });

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        namaKategori: json["nama_kategori"],
        slug: json["slug"],
        gambar: json["gambar"],
        deletedAt: json['deleted_at'] == "0001-01-01T00:00:00Z" ? null : DateTime.parse(json["deleted_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_kategori": namaKategori,
        "slug": slug,
        "gambar": gambar,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  // fungsi untuk konversi list dynamic ke list kategori
  static List<Category>? fetchFromDynamicList(dynamic list) {
    List<Category> categories = [];

    if (list == null) {
      return null;
    }

    if ((list as List<dynamic>).isEmpty) {
      return null;
    }

    for (int i = 0; i < list.length; i++) {
      categories.add(Category.fromJson(list[i]));
    }
    return categories;
  }
}

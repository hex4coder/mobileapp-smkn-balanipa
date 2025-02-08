import 'dart:convert';

class Brand {
  int id;
  String name;
  String slug;
  String logo;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Brand({
    required this.id,
    required this.name,
    required this.slug,
    required this.logo,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Brand.fromRawJson(String str) => Brand.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        logo: json["logo"],
        deletedAt: json['deleted_at'] == "0001-01-01T00:00:00Z" ? null : DateTime.parse(json["deleted_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "logo": logo,
        "deleted_at": deletedAt?.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  static List<Brand> convertFromListDynamic(List<dynamic> list) {
    List<Brand> brands = [];

    if (list.isNotEmpty) {
      for (var item in list) {
        brands.add(Brand.fromJson(item));
      }
    }

    return brands;
  }
}

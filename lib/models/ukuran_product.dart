import 'dart:convert';

class UkuranProduct {
  int id;
  int produkId;
  String ukuran;
  DateTime deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  UkuranProduct({
    required this.id,
    required this.produkId,
    required this.ukuran,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UkuranProduct.fromRawJson(String str) =>
      UkuranProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UkuranProduct.fromJson(Map<String, dynamic> json) => UkuranProduct(
        id: json["id"],
        produkId: json["produk_id"],
        ukuran: json["ukuran"],
        deletedAt: DateTime.parse(json["deleted_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "produk_id": produkId,
        "ukuran": ukuran,
        "deleted_at": deletedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  static List<UkuranProduct> getListUkuran(List<dynamic> listDynamic) {
    List<UkuranProduct> listUkuran = [];

    if (listDynamic.isNotEmpty) {
      for (var item in listDynamic) {
        listUkuran.add(UkuranProduct.fromJson(item));
      }
    }

    return listUkuran;
  }
}

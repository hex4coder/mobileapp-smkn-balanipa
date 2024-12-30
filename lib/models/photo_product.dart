import 'dart:convert';

class PhotoProduct {
  int id;
  int produkId;
  String foto;
  DateTime deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  PhotoProduct({
    required this.id,
    required this.produkId,
    required this.foto,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PhotoProduct.fromRawJson(String str) =>
      PhotoProduct.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhotoProduct.fromJson(Map<String, dynamic> json) => PhotoProduct(
        id: json["id"],
        produkId: json["produk_id"],
        foto: json["foto"],
        deletedAt: DateTime.parse(json["deleted_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "produk_id": produkId,
        "foto": foto,
        "deleted_at": deletedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  static List<PhotoProduct> getListPhotos(List<dynamic> listDynamic,
      {String thumbnail = ''}) {
    List<PhotoProduct> listPhoto = [];
    if (listDynamic.isNotEmpty) {
      for (var item in listDynamic) {
        listPhoto.add(PhotoProduct.fromJson(item));
      }
    }

    final first = listPhoto.first;

    if (thumbnail.isNotEmpty) {
      listPhoto.add(PhotoProduct(
          id: -1, // thumbnail indicator
          produkId: first.produkId,
          foto: thumbnail,
          deletedAt: first.deletedAt,
          createdAt: first.createdAt,
          updatedAt: first.updatedAt));
    }

    // sort the list
    listPhoto.sort((a, b) => a.id.compareTo(b.id));

    return listPhoto;
  }
}

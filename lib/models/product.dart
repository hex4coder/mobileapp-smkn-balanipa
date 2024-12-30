import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());


class Product {
  int id;
  String nama;
  String deskripsi;
  int harga;
  int stok;
  bool isPopular;
  String thumbnail;
  int kategoriId;
  int brandId;
  DateTime deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  static List<Product> getFromListDynamic(List<dynamic> data) {
    List<Product> l = [];
    for (int i = 0; i < data.length; i++) {
      l.add(Product.fromJson(data[i]));
    }
    return l;
  }

  Product({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.harga,
    required this.stok,
    required this.isPopular,
    required this.thumbnail,
    required this.kategoriId,
    required this.brandId,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        nama: json["nama"],
        deskripsi: json["deskripsi"],
        harga: json["harga"],
        stok: json["stok"],
        isPopular: json["is_popular"],
        thumbnail: json["thumbnail"],
        kategoriId: json["kategori_id"],
        brandId: json["brand_id"],
        deletedAt: DateTime.parse(json["deleted_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "deskripsi": deskripsi,
        "harga": harga,
        "stok": stok,
        "is_popular": isPopular,
        "thumbnail": thumbnail,
        "kategori_id": kategoriId,
        "brand_id": brandId,
        "deleted_at": deletedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

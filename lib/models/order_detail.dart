import 'dart:convert';

class OrderDetail {
  int id;
  int pesananId;
  int produkId;
  String? ukuran;
  String? keterangan;
  int harga;
  int jumlah;
  int total;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  OrderDetail({
    required this.id,
    required this.pesananId,
    required this.produkId,
    required this.ukuran,
    required this.keterangan,
    required this.harga,
    required this.jumlah,
    required this.total,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDetail.fromRawJson(String str) =>
      OrderDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["id"],
        pesananId: json["pesanan_id"],
        produkId: json["produk_id"],
        ukuran: json["ukuran"],
        keterangan: json["keterangan"],
        harga: json["harga"],
        jumlah: json["jumlah"],
        total: json["total"],
        deletedAt: json["deleted_at"] != null
            ? DateTime.parse(json["deleted_at"])
            : null,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pesanan_id": pesananId,
        "produk_id": produkId,
        "ukuran": ukuran,
        "keterangan": keterangan,
        "harga": harga,
        "jumlah": jumlah,
        "total": total,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

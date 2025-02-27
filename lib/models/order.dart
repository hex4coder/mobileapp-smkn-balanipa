import 'dart:convert';

class Order {
  int id;
  DateTime tanggal;
  String status;
  int totalHargaProduk;
  int totalDiskon;
  int totalBayar;
  String buktiTransfer;
  bool sudahTerbayar;
  String codePromo;
  int userId;
  DateTime? deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  Order({
    required this.id,
    required this.tanggal,
    required this.status,
    required this.totalHargaProduk,
    required this.totalDiskon,
    required this.totalBayar,
    required this.buktiTransfer,
    required this.sudahTerbayar,
    required this.codePromo,
    required this.userId,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        tanggal: DateTime.parse(json["tanggal"]),
        status: json["status"],
        totalHargaProduk: json["total_harga_produk"],
        totalDiskon: json["total_diskon"],
        totalBayar: json["total_bayar"],
        buktiTransfer: json["bukti_transfer"],
        sudahTerbayar: json["sudah_terbayar"],
        codePromo: json["code_promo"],
        userId: json["user_id"],
        deletedAt: json["deleted_at"] == null
            ? null
            : DateTime.parse(json["deleted_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tanggal": tanggal.toIso8601String(),
        "status": status,
        "total_harga_produk": totalHargaProduk,
        "total_diskon": totalDiskon,
        "total_bayar": totalBayar,
        "bukti_transfer": buktiTransfer,
        "sudah_terbayar": sudahTerbayar,
        "code_promo": codePromo,
        "user_id": userId,
        "deleted_at": deletedAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

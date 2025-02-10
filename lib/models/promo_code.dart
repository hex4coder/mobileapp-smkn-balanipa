import 'dart:convert';

class PromoCode {
  final String code;
  final String type;
  final int discount;
  final DateTime createdAt;
  final DateTime updatedAt;

  PromoCode({
    required this.code,
    required this.type,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PromoCode.fromRawJson(String str) =>
      PromoCode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
        code: json["code"],
        type: json["type"],
        discount: json["discount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "type": type,
        "discount": discount,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };

  double getDiscount(int totalBayar) {
    double total = 0;

    if (type == "percent") {
      total = (discount.toInt() / 100) * totalBayar;
    }

    if (type == "fixed") {
      total = (discount).toDouble();
    }

    return total;
  }
}

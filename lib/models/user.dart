class User {
  int id;
  String name;
  String email;
  String password;
  Address? address;
  int role; // 0 admin, 1 customer

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });
}

class Address {
  int id;
  String nomorhp;
  String jalan;
  String dusun;
  String desa;
  String kecamatan;
  String kota;
  String provinsi;
  String kodepos;

  Address({
    required this.id,
    required this.jalan,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kota,
    required this.provinsi,
    required this.nomorhp,
    required this.kodepos,
  });
}

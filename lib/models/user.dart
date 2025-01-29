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
    this.address,
  });

  factory User.fromMap(Map<String, dynamic> data,
      {bool withoutAddress = true}) {
    User u = User(
        id: data['id'],
        name: data['name'],
        email: data['email'],
        password: data['password'],
        role: data['role']);

    if (withoutAddress == false) {
      if (data['address'] != null &&
          data['address'] != "" &&
          data['address']['id'] != null) {
        u.address = Address.fromMap(data['address']);
      }
    }

    return u;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'address': address == null ? "" : address!.toMap(),
    };
  }
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

  factory Address.fromMap(Map<String, dynamic> data) {
    return Address(
        id: data['id'],
        jalan: data['jalan'],
        dusun: data['dusun'],
        desa: data['desa'],
        kecamatan: data['kecamatan'],
        kota: data['kota'],
        provinsi: data['provinsi'],
        nomorhp: data['nomorhp'],
        kodepos: data['kodepos']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jalan': jalan,
      'dusun': dusun,
      'desa': desa,
      'kecamatan': kecamatan,
      'kota': kota,
      'provinsi': provinsi,
      'nomorhp': nomorhp,
      'kodepos': kodepos,
    };
  }
}

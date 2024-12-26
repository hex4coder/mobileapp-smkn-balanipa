import 'package:get_storage/get_storage.dart';

// class helper untuk operasi simpan token
// digunakan untuk membantu http request dalam
// komunikasi ke server api
class ApiTokenHelper {
  // local key untuk simpan token
  final String _key = "token_ua";

  // storage untu penyimpanan token
  late GetStorage _box;

  // inisialiasi local storage
  static Future<void> initialize() async {
    await GetStorage.init();
  }

  // buat instanse baru
  ApiTokenHelper() {
    _box = GetStorage();
  }

  // simpan token ke storage
  Future<void> save(String newToken) async {
    await reset();
    await _box.write(_key, newToken);
  }

  // untuk mengecek jika token ada
  bool hasToken() {
    return _box.hasData(_key);
  }

  // ambil token dari storage
  String get() {
    return _box.read(_key) ?? "";
  }

  // hapus token dari storage
  Future<void> remove() async {
    await _box.remove(_key);
  }

  // reset storage
  Future<void> reset() async {
    await _box.erase();
  }
}

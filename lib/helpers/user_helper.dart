// user helper adalah helper untuk menangani data user yang akan disimpan ke local storage

import 'package:get_storage/get_storage.dart';
import 'package:myapp/models/user.dart';

class UserHelper {
  // untuk menjadi key yang disimpan ke database
  static const String userKey = 'ua-user-helper';

  // local storage box
  late GetStorage _box;

  // buat konstructor untuk user helper
  UserHelper() {
    // inisialisasi storage
    _box = GetStorage('user-profile');
  }

  // reset
  Future<void> reset() async {
    await _box.remove(userKey);
    await _box.erase();
  }

  // save to storage
  Future<void> save(User user) async {
    await reset();
    await _box.write(userKey, user.toMap());
    await _box.save();
  }

  // load from storage
  Future<User?> load() async {
    final userMap = _box.read(userKey);
    if (userMap == null) {
      return null;
    }

    final user = User.fromMap(userMap, withoutAddress: false);
    print(user);
    return user;
  }
}

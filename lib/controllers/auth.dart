import 'package:get/get.dart';
import 'package:myapp/models/user.dart';

class AuthController extends GetxController {
  // variables
  late Rx<User?> _user;

  // constructor
  AuthController() {
    _user = Rx<User?>(null);
  }

  // functions
  Future<void> login() async {}
  Future<void> register() async {}

  // getter and setter
  bool get isLoggedIn => _user.value?.id != null;

  User? get user => _user.value;
  set user(User? value) => _user.value = value;
}

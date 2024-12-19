import 'package:get/get.dart';
import 'package:myapp/models/user.dart';

class AuthController extends GetxController {
  // variables
  late Rx<User?> _user;
  final Rx<String> _token = ''.obs;

  // constructor
  AuthController() {
    _user = Rx<User?>(null);
  }

  // functions
  void login() {}
  void register() {}

  // getter and setter
  bool get isLoggedIn => _user.value?.id != null;

  User? get user => _user.value;
  set user(User? value) => _user.value = value;

  String get token => _token.value;
  set token(String newToken) => _token.value = newToken;
}

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/models/api_response_model.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/models/user.dart';

class RegisterUserRequest {
  String name;
  String email;
  String password;

  String nomorhp;
  String jalan;
  String dusun;
  String desa;
  String kecamatan;
  String kota;
  String provinsi;
  String kodepos;

  RegisterUserRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.jalan,
    required this.dusun,
    required this.desa,
    required this.kecamatan,
    required this.kota,
    required this.provinsi,
    required this.nomorhp,
    required this.kodepos,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
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

  factory RegisterUserRequest.fromMap(Map<String, dynamic> data) {
    return RegisterUserRequest(
        name: data['name'],
        email: data['email'],
        password: data['password'],
        jalan: data['jalan'],
        dusun: data['dusun'],
        desa: data['desa'],
        kecamatan: data['kecamatan'],
        kota: data['kota'],
        provinsi: data['provinsi'],
        nomorhp: data['nomorhp'],
        kodepos: data['kodepos']);
  }
}

class LoginUserRequest {
  String email;
  String password;

  LoginUserRequest({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory LoginUserRequest.fromMap(Map<String, dynamic> data) {
    return LoginUserRequest(email: data['email'], password: data['password']);
  }
}

class AuthController extends GetxController {
  // variables
  late Rx<User?> _user;
  late GetStorage _storage;
  final _loading = false.obs;

  // api helper
  late ApiHttp _api;

  // constructor
  AuthController() {
    _user = Rx<User?>(null);
    _api = Get.find<ApiHttp>();
  }

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage("user-profile");
    initialize().then((_) {});
  }

  // load init
  Future<void> initialize() async {}

  // functions
  Future<bool> login(LoginUserRequest req) async {
    _loading.value = true;

    final res = await _api.post('/login', req.toMap());

    _loading.value = false;

    if (res.status == ResponseType.error) {
      UiSnackbar.error('Autentikasi gagal', res.message);
      return false;
    }

    // TODO: login success, extract jwt token

    return true;
  }

  Future<bool> register(RegisterUserRequest req) async {
    _loading.value = true;

    final res = await _api.post('/register', req.toMap());

    _loading.value = false;

    if (res.status == ResponseType.error) {
      UiSnackbar.error('Register failed', res.message);
      return false;
    }

    return true;
  }

  // getter and setter
  bool get isLoggedIn => _user.value?.id != null;
  bool get isloading => _loading.value;

  User? get user => _user.value;
  set user(User? value) => _user.value = value;
}

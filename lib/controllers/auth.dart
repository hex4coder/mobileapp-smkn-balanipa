import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/api_token.dart';
import 'package:myapp/helpers/models/api_response_model.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/helpers/user_helper.dart';
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
  final _loading = false.obs;

  // api helper
  late ApiHttp _api;
  late ApiTokenHelper _token;
  late UserHelper _userHelper;

  late Timer _t;

  // constructor
  AuthController() {
    _user = Rx<User?>(null);
    _token = Get.find<ApiTokenHelper>();
    _api = Get.find<ApiHttp>();
    _userHelper = Get.find<UserHelper>();
  }

  @override
  void onClose() {
    closeTimer();
    super.onClose();
  }

  void closeTimer() {
    if (isClosed) {
      if (_t.isActive) {
        _t.cancel();
      }
    }
  }

  // timer token
  //
  void timerToken() async {
    await Future.delayed(const Duration(milliseconds: 100));
    Timer.periodic(const Duration(minutes: 5), (Timer t) async {
      _t = t;
      closeTimer();
      await renewToken();
    });
  }

  // load init
  Future<void> initialize() async {
    // load user from storage if exists
    final user = await _userHelper.load();
    _user.value = user;
  }

  // functions
  Future<bool> login(LoginUserRequest req) async {
    _loading.value = true;

    final res = await _api.post('/login', req.toMap());

    if (res.status == ResponseType.error) {
      UiSnackbar.error('Autentikasi gagal', res.message);
      _loading.value = false;
      return false;
    }

    // extract token dari server
    final String newToken = res.data['jwt'];
    if (newToken.isEmpty) return false;

    // lakukan penyimpanan jwt di local storage
    await _token.save(newToken);

    // buat http baru dengan token helper
    final newApi =
        Get.put(ApiHttp()..newApiHttpWithTokenInterceptor(), permanent: true);
    newApi.newApiHttpWithTokenInterceptor();
    _api = newApi;

    // ambil detail user dari server
    final reqUser = await _api.get('/user');
    if (reqUser.status == ResponseType.error) {
      UiSnackbar.error('Request user error', reqUser.message);
      _loading.value = false;
      return false;
    }
    final user = User.fromMap(
      reqUser.data,
    );

    // ambil user address
    final userAddressReq = await _api.get('/user-address');
    if (userAddressReq.status == ResponseType.error) {
      UiSnackbar.error('User address error', userAddressReq.message);
      _loading.value = false;
      return false;
    }
    final userAddress = Address.fromMap(userAddressReq.data);
    user.address = userAddress;

    // set user password to current password
    user.password = req.password;

    // simpan user ke local storage
    await _userHelper.save(user);

    // update user rx
    _user.value = user;

    // update status login
    _loading.value = false;

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

  Future<void> checkUserToken() async {
    if (!_userHelper.hasUser()) return; // belum login

    // jika sudah login, lakukan pengecekan token
    // dan jika token sudah expired maka, perbarui token

    _loading.value = true;
    final res = await _api.get("/check-token");
    _loading.value = false;

    if (res.isError) {
      // token expired renrw token
      await renewToken();
    }
  }

  // renew token
  Future<void> renewToken() async {
    // get email and password from current user data
    final User user = _user.value!;
    String email = user.email;
    String password = user.password; // this is not the hashed password

    // create new login request
    final LoginUserRequest loginReq =
        LoginUserRequest(email: email, password: password);

    // login to system
    bool success = await login(loginReq);

    // check
    if (!success) {
      UiSnackbar.error("Failed renew token", "Token gagal diperbaharui.");
    } else {
      if (kDebugMode) {
        UiSnackbar.success("Token renewed", "Token anda diperbaharui");
      }
    }
  }

  // sign out user
  Future<void> signout() async {
    _loading.value = true;

    // clear token
    final tokenHandler = Get.find<ApiTokenHelper>();
    await tokenHandler.reset();

    // remove user
    await _userHelper.reset();

    // set user to null
    _user.value = null;

    _loading.value = false;

    // toast
    Fluttertoast.showToast(msg: "Anda telah logout. Silahkan login kembali!");
  }

  // getter and setter
  bool get isLoggedIn => _user.value?.id != null;
  bool get isloading => _loading.value;

  User? get user => _user.value;

  String get tokenError => "token has invalid claims: token is expired";
}

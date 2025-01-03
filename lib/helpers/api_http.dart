import 'package:dio/dio.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/helpers/interceptors/response_interceptor.dart';
import 'package:myapp/helpers/interceptors/token_interceptor.dart';
import 'package:myapp/helpers/models/api_response_model.dart';

// helper untuk mengelola api
// menggunakan dio untuk komunikasi
// ke server
class ApiHttp {
  // inisialisasi object dio
  late Dio _dio;

  // konfigurasi untuk base url
  // dan option lainnya
  void _configure() {
    // tetapkan base url
    _dio.options.baseUrl = ServerConfig.kServerBaseAPI;

    // atur waktu pembacaan data dari server
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);

    // pastikan content type adalah json
    _dio.options.headers['Content-Type'] = 'application/json';

    // manipulasi data response sebelum dikonsumsi oleh penerima
    _dio.interceptors.add(ResponseInterceptor());
  }

  // inisialisasi
  ApiHttp() {
    _dio = Dio();
    _configure();
  }

  // buat api service dengan token interceptor
  newApiHttpWithTokenInterceptor() {
    _dio = Dio();
    _configure();
    // token interceptor digunakan untuk manipulasi request http
    // dalam penambahan bearer token ke header Authorization
    _dio.interceptors.add(TokenInterceptor()); // penambahan token interceptor
  }

  // fungsi untuk menambahkan interceptor baru ke api http
  addInterceptorToApiHttp(Interceptor newInterceptor) {
    _dio.interceptors.add(newInterceptor);
  }

  // Get request dengan api response
  Future<ApiResponse> get(String path) async {
    var r = await _get(path);

    return r.data as ApiResponse;
  }

  // Post request dengan api response
  Future<ApiResponse> post(String path, Map<String, dynamic> data) async {
    var r = await _post(path, data);
    return r.data as ApiResponse;
  }

  // Delete request dengan api response
  Future<ApiResponse> delete(String path) async {
    var r = await _delete(path);
    return r.data as ApiResponse;
  }

  // get request
  Future<Response> _get(String path) async {
    return await _dio.get(path);
  }

  // post request
  Future<Response> _post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  // delete request
  Future<Response> _delete(String path) async {
    return await _dio.delete(path);
  }
}

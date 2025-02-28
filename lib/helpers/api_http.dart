import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/helpers/api_token.dart';
import 'package:myapp/helpers/interceptors/response_interceptor.dart';
import 'package:myapp/helpers/interceptors/token_interceptor.dart';
import 'package:myapp/helpers/models/api_response_model.dart';

// enum content type for http request
enum ContentTypeRequest {
  json,
  multipartFormData,
}

// helper untuk mengelola api
// menggunakan dio untuk komunikasi
// ke server
class ApiHttp {
  // inisialisasi object dio
  late Dio _dio;

  late ApiTokenHelper _tokenHelper;

  final String errTokenExpired = "token has invalid claims: token is expired";

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
    _tokenHelper = Get.find();

    _dio = Dio();
    _configure();

    if (_tokenHelper.hasToken()) {
      newApiHttpWithTokenInterceptor();
    }
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
    try {
      final r = await _dio.get(path);
      final res = r.data as ApiResponse;

      if (res.message == errTokenExpired) {
        // renew token

        final AuthController auth = Get.find();
        await auth.renewToken();
        return ApiResponse.error(errTokenExpired);
      } else {
        return res;
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return ApiResponse.error('server tidak bisa dijangkau');
      } else {
        return ApiResponse.fromMap(e.response!.data);
      }
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  // Post request dengan api response
  Future<ApiResponse> post(String path, Object? data,
      {ContentTypeRequest postDataType = ContentTypeRequest.json}) async {
    try {
      // update header for request based on post data type
      switch (postDataType) {
        case ContentTypeRequest.multipartFormData:
          _dio.options.headers["Content-Type"] = "multipart/form-data";
          break;
        default:
          _dio.options.headers['Content-Type'] = "application/json";
      }

      final r = await _dio.post(path, data: data);

      final res = r.data as ApiResponse;
      if (res.message == errTokenExpired) {
        // renew token

        final AuthController auth = Get.find();
        await auth.renewToken();

        return ApiResponse.error(errTokenExpired);
      } else {
        return res;
      }
    } on DioException catch (e) {
      if (e.response == null) {
        return ApiResponse.error('server tidak bisa dijangkau');
      } else {
        return ApiResponse.fromMap(e.response!.data);
      }
    }
  }

  // Delete request dengan api response
  Future<ApiResponse> delete(String path) async {
    try {
      final r = await _dio.delete(path);
      return r.data as ApiResponse;
    } on DioException catch (e) {
      if (e.response == null) {
        return ApiResponse.error('server tidak bisa dijangkau');
      } else {
        return ApiResponse.fromMap(e.response!.data);
      }
    }
  }
}

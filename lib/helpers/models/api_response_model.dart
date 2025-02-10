import 'package:dio/dio.dart';
import 'package:myapp/helpers/ui_snackbar.dart';

enum ResponseType { success, error }

class ApiResponse {
  String message;
  ResponseType status;
  dynamic data;

  ApiResponse({required this.message, required this.status, this.data});

  bool get isError => status == ResponseType.error;

  static ApiResponse success(String message, dynamic data) {
    return ApiResponse(
        message: message, status: ResponseType.success, data: data);
  }

  // buat response yang menandakan error
  static ApiResponse error(String message) {
    // tampilkan pesan kesalahan
    UiSnackbar.error('error', message);

    return ApiResponse(
        message: message, status: ResponseType.error, data: null);
  }

  // konversi dio response kedalam ApiResponse
  static ApiResponse fromDioResponse(Response r) {
    var rdata = r.data;
    if (r.statusCode == 200) {
      if (rdata['data'] != null) {
        return ApiResponse.success(rdata['message'], rdata['data']);
      } else {
        return ApiResponse.error(rdata['message']);
      }
    } else {
      return ApiResponse.error(rdata['message']);
    }
  }

  static ApiResponse fromMap(Map<String, dynamic> data) {
    return ApiResponse(
        message: data['message'],
        status: data['status'] == 'error'
            ? ResponseType.error
            : ResponseType.success,
        data: data['data']);
  }
}

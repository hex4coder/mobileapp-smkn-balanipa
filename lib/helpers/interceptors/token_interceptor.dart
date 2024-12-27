import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/api_token.dart';

// token interceptor adalah interceptor
// untuk injeksi token kedalam http request
// sebelum dikirim ke server
class TokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final t = Get.find<ApiTokenHelper>();
    options.headers['Authorization'] = t.getBearer();
    super.onRequest(options, handler);
  }
}

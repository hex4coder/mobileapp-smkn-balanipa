import 'package:dio/dio.dart';
import 'package:myapp/helpers/models/api_response_model.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // ubah response data menjadi api response
    final res = ApiResponse.fromDioResponse(response);
    response.data = res;

    super.onResponse(response, handler);
  }
}

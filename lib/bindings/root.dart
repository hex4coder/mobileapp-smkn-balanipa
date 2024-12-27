import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/api_token.dart';
// import 'package:myapp/controllers/product.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    // coba inject api helper
    Get.put<ApiTokenHelper>(ApiTokenHelper(), permanent: true);

    // inject api http helper
    Get.put<ApiHttp>(ApiHttp());
  }
}

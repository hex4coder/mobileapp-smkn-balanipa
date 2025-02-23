import 'package:get/get.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/controllers/order.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/controllers/promocode.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/api_token.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/helpers/user_helper.dart';
// import 'package:myapp/controllers/product.dart';

class RootBinding implements Bindings {
  @override
  void dependencies() {
    // coba inject api helper
    Get.put<ApiTokenHelper>(ApiTokenHelper(), permanent: true);

    // user helper
    Get.put<UserHelper>(UserHelper());

    // inject api http helper
    Get.put<ApiHttp>(ApiHttp(), permanent: true);

    // inject auth controller
    Get.put<AuthController>(AuthController());

    // inject product controller
    Get.put<ProductController>(ProductController());

    // inject cart helper
    Get.put<CartHelper>(CartHelper(), permanent: true);

    // promo controller
    Get.put<PromoCodeController>(PromoCodeController());

    // inject order api
    Get.put<OrderController>(OrderController());
  }
}

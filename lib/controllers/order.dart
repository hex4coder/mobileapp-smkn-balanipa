import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/ui_snackbar.dart';

class OrderController extends GetxController {
  // order controller

  late ApiHttp api;

  @override
  void onInit() {
    api = Get.find(); // api http
    super.onInit();
  }

  // get list orders
  Future<void> getMyOrders() async {
    // try
    final res = await api.get('/my-orders');

    // check
    if (res.isError) {
      UiSnackbar.error("Fetch Order Failed", res.message);
      return;
    }
  }
}

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:dio/dio.dart' as d;
import 'package:myapp/models/order.dart';

class OrderController extends GetxController {
  // order controller

  late ApiHttp api;
  final RxList<Order> _orders = RxList.empty();

  List<Order> get listOrders => _orders;

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

    // create orders list
    List<Order> orders = [];

    // mapping data to orders
    final ordersdata = res.data as List<dynamic>;
    for (var order in ordersdata) {
      orders.add(Order.fromJson(order));
    }

    // update new data
    _orders.assignAll(orders);
  }

  // create new order
  Future<bool> createNewOrder(d.FormData data) async {
    // post data to server
    final res = await api.post('/order', data,
        postDataType: ContentTypeRequest.multipartFormData);

    // error
    if (res.isError) {
      Fluttertoast.showToast(msg: "Terjadi kesalahan.");
      UiSnackbar.error('Error', res.message);
      return false;
    }

    return true;
  }
}

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:dio/dio.dart' as d;
import 'package:myapp/models/order.dart';
import 'package:myapp/models/order_detail.dart';
import 'package:myapp/screens/product/detail.dart';

// cancel order class
class CancelOrderRequest {
  String alasanPembatalan;
  int orderId;

  CancelOrderRequest({required this.orderId, required this.alasanPembatalan});

  Map<String, dynamic> toJSON() {
    return {
      "alasan_pembatalan": alasanPembatalan,
      "order_id": orderId,
    };
  }
}

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

  // get status order
  Future<String> getStatusOrder(int orderId) async {
    final res = await api.post("/get-order-status", <String, dynamic>{
      "order_id": orderId,
    });

    if (res.isError) {
      UiSnackbar.error("cancel order failed", res.message);
      return "";
    }

    // not error
    return res.data["status"];
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

  // cancel my orders
  Future<bool> cancelMyOrder(CancelOrderRequest req) async {
    // create request to server
    final res = await api.post("/cancel-order", req.toJSON());

    if (res.isError) {
      UiSnackbar.error("cancel order failed", res.message);
      return false;
    }

    // not error
    return true;
  }

  Future<bool> deleteMyOrders(int orderId) async {
    // create request to server
    final res = await api.post("/delete-order", {"order_id": orderId});

    if (res.isError) {
      UiSnackbar.error("delete order failed", res.message);
      return false;
    }

    // not error
    return true;
  }

  // get details order
  //
  Future<List<OrderDetail>> getDetailOrder(int orderId) async {
    // create request to server
    final res = await api.post("/detail-order", {"order_id": orderId});

    if (res.isError) {
      UiSnackbar.error("fetch detail order failed", res.message);
      return [];
    }

    // parsing data
    // loop data
    //
    final List<OrderDetail> details = [];
    if (res.data["details"].isNotEmpty) {
      for (var d in res.data["details"]) {
        details.add(OrderDetail.fromJson(d));
      }
    }

    // not error
    return details;
  }
}

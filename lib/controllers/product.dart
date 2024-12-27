import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/models/api_response_model.dart';
import 'package:myapp/models/product.dart';

class ProductController extends GetxController {
  // vars
  final _listProduct = <Product>[].obs;
  final _loading = false.obs;
  late ApiHttp _api;

  @override
  void onInit() {
    _api = Get.find<ApiHttp>();
    fetchAll();
    super.onInit();
  }

  // function
  Future<void> fetchAll() async {
    _loading.value = true;
    final res = await _api.get('/products');

    if (res.status == ResponseType.error) {
      setListProduct([]);
      _loading.value = false;
      return;
    }

    final listData = Product.getFromListDynamic(res.data);
    setListProduct(listData);
    _loading.value = false;
  }

  Future<Product?> fetchByID(int id) async {
    _loading.value = true;
    final res = await _api.get('/products');
    _loading.value = false;
    if (res.status == ResponseType.error) {
      return null;
    }
    final product = Product.fromJson(res.data);
    return product;
  }

  Future<void> fetchByCategoryID(int categoriID) async {
    _loading.value = true;
    final res = await _api.get('/categories/$categoriID');
    if (res.status == ResponseType.error) {
      setListProduct([]);
      _loading.value = false;
      return;
    }
    final listData = Product.getFromListDynamic(res.data);
    setListProduct(listData);
    _loading.value = false;
  }

  Future<void> fetchByBrandID(int brandID) async {
    _loading.value = true;
    final res = await _api.get('/brand/$brandID');
    if (res.status == ResponseType.error) {
      setListProduct([]);
      _loading.value = false;
      return;
    }
    final listData = Product.getFromListDynamic(res.data);
    setListProduct(listData);
    _loading.value = false;
  }

  // setters and getters
  List<Product> get listProduct => _listProduct;
  bool get isLoading => _loading.value;
  void setListProduct(List<Product> newData) => _listProduct.assignAll(newData);
}

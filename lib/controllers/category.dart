import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/models/api_response_model.dart';
import 'package:myapp/models/category.dart';

class CategoryController extends GetxController {
  // mengindikasikan proses fetch data sedang berjalan
  final _isloading = false.obs;

  // menyimpan list data
  final RxList<Category> _list = RxList<Category>.empty();

  // api http helper untuk komunikasi ke server
  late ApiHttp _api;

  @override
  void onInit() {
    // inisialisasi api http
    _api = Get.find<ApiHttp>();

    // jalankan fungsi fetching data brands
    fetchAll();

    super.onInit();
  }

  // lakukan fetching data dari server
  Future<void> fetchAll() async {
    // reset list
    _reset();

    // loading
    isloading = true;

    // fetch data from server
    final res = await _api.get('/categories');

    // error handlers
    if (res.status == ResponseType.error) {
      // stop loading
      isloading = false;
      return;
    }

    // ambil dari data
    final cats = Category.fetchFromDynamicList(res.data);
    if (cats != null) {
      list = cats;
    }

    // stop loading
    isloading = false;
  }

  // clear the list
  void _reset() {
    list = [];
  }

  // setters
  set isloading(bool v) => _isloading.value = v;
  set list(List<Category> newList) => _list.assignAll(newList);

  // getters
  bool get isloading => _isloading.value;
  List<Category> get list => _list;
}

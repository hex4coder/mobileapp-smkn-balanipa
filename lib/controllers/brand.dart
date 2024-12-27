import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/models/api_response_model.dart';
import 'package:myapp/models/brand.dart';

// BrandController akan digunakan untuk fetching
// data brands dari API server
class BrandController extends GetxController {
  // mengindikasikan proses fetch data sedang berjalan
  final _isloading = false.obs;

  // list data
  final RxList<Brand> _brands = RxList.empty();

  // api http helper
  late ApiHttp _api;

  @override
  void onInit() {
    // inisialisasi api helper
    _api = Get.find<ApiHttp>();

    // jalankan fungsi fetching data brands
    super.onInit();
  }

  // fetch all brands
  Future<void> fetchAll() async {
    // kosongkan data
    _reset();

    // loading
    isloading = true;

    // request data ke server
    final res = await _api.get('/brands');

    // jika error jangan lakukan apapun
    if (res.status == ResponseType.error) {
      isloading = false;
      return;
    }

    // decode new data
    final newData = Brand.convertFromListDynamic(res.data);

    // set to list
    brands = newData;

    // stop loading
    isloading = false;
  }

  // fetch by id
  Future<void> fetchById(int brandId) async {
    throw Exception("brand fetchById belum diimplementasikan");
  }

  // reset semua list brands
  void _reset() {
    brands.clear();
  }

  // getters
  bool get isloading => _isloading.value;
  List<Brand> get brands => _brands;

  // setter
  set brands(List<Brand> listData) => _brands.assignAll(listData);
  set isloading(bool v) => _isloading.value = v;
}

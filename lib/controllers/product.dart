import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/models/api_response_model.dart';
import 'package:myapp/models/brand.dart';
import 'package:myapp/models/category.dart';
import 'package:myapp/models/photo_product.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/models/ukuran_product.dart';

// berisi response untuk detail produk
class DetailProductResponse {
  Product product;
  Category kategori;
  Brand brand;
  List<PhotoProduct> listPhoto;
  List<UkuranProduct> listUkuran;

  DetailProductResponse({
    required this.product,
    required this.kategori,
    required this.brand,
    required this.listPhoto,
    required this.listUkuran,
  });
}

// berisi controller tentang product
class ProductController extends GetxController {
  // vars

  // data store
  final _listProduct = <Product>[].obs;

  // loading indicator
  final _loading = false.obs;

  // api helper
  late ApiHttp _api;

  @override
  void onInit() {
    // init api helper
    _api = Get.find<ApiHttp>();

    // fetching data from server
    fetchPopularProducts(5);

    // super constructor init
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

  Future<DetailProductResponse?> fetchDetailProduct(int id) async {
    // _loading.value = true;
    final res = await _api.get('/products');
    // _loading.value = false;
    if (res.status == ResponseType.error) {
      return null;
    }

    final brand = Brand.fromJson(res.data['brand']);
    final cat = Category.fromJson(res.data['kategori']);
    final product = Product.fromJson(res.data['product']);
    final listUkuran = UkuranProduct.getListUkuran(res.data['ukuran']);
    final listPhoto = PhotoProduct.getListPhotos(res.data['photos'],
        thumbnail: product.thumbnail);

    final detRes = DetailProductResponse(
        product: product,
        kategori: cat,
        brand: brand,
        listPhoto: listPhoto,
        listUkuran: listUkuran);

    return detRes;
  }

  Future<void> fetchByCategoryID(int categoriID) async {
    _loading.value = true;
    final res = await _api.get('/kategori/$categoriID');
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

  // get list of popular products
  Future<void> fetchPopularProducts(int limit) async {
    _loading.value = true;
    final res = await _api.get('/popular-products/$limit');
    if (res.status == ResponseType.error) {
      setListProduct([]);
      _loading.value = false;
      return;
    }
    final listData = Product.getFromListDynamic(res.data);
    setListProduct(listData);
    _loading.value = false;
  }

  // set list product
  void setListProduct(List<Product> newData) => _listProduct.assignAll(newData);

  // setters and getters
  List<Product> get listProduct => _listProduct;
  bool get isLoading => _loading.value;
}

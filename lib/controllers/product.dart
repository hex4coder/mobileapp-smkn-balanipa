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

class ProductsByCategory {
  int kategoriId;
  String kategori;
  List<Product> products;

  ProductsByCategory(
      {required this.kategoriId,
      required this.kategori,
      required this.products});
}

// berisi controller tentang product
class ProductController extends GetxController {
  // vars

  // data store
  final _listProduct = <Product>[].obs;

  // data store by cats
  final _listByCats = <ProductsByCategory>[].obs;

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
    listData.sort((a, b) => a.kategoriId.compareTo(b.kategoriId));
    setListProduct(listData);

    // ambil semua kategori
    _listByCats.clear();

    final r = await _api.get('/categories');
    if (r.status == ResponseType.error) {
      return;
    }

    final cats = Category.fetchFromDynamicList(r.data);
    if (cats == null) {
      return;
    }
    List<ProductsByCategory> temps = [];
    for (var cat in cats) {
      List<Product> temp = [];
      for (var product in listData) {
        if (cat.id == product.kategoriId) {
          temp.add(product);
        }
      }

      if (temp.isNotEmpty) {
        temps.add(ProductsByCategory(
            kategoriId: cat.id, kategori: cat.namaKategori, products: temp));
      }
    }

    _listByCats.assignAll(temps);

    _loading.value = false;
  }

  Future<DetailProductResponse?> fetchDetailProduct(int id) async {
    // _loading.value = true;
    final res = await _api.get('/product/$id');
    // _loading.value = false;
    if (res.status == ResponseType.error) {
      return null;
    }

    final brand = Brand.fromJson(res.data['brand']);
    // print(brand.toJson());
    final cat = Category.fromJson(res.data['kategori']);
    // print(cat.toJson());
    final product = Product.fromJson(res.data['product']);
    // print(product.toJson());
    final listUkuran = UkuranProduct.getListUkuran(res.data['ukuran']);
    // print(listUkuran);
    final listPhoto = PhotoProduct.getListPhotos(res.data['photos'],
        thumbnail: product.thumbnail);
    // print(listPhoto);

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
  List<ProductsByCategory> get listByCats => _listByCats;
  bool get isLoading => _loading.value;
}

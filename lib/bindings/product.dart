import 'package:get/get.dart';
import 'package:myapp/controllers/brand.dart';
import 'package:myapp/controllers/category.dart';
import 'package:myapp/controllers/product.dart';

// product binding untuk mengelolah semua dependensi untuk produk

class ProductBinding implements Bindings {
  // constructor
  ProductBinding();

  @override
  void dependencies() {
    // injeksi kategori controller
    Get.put(CategoryController());

    // injeksi product controller
    Get.put(ProductController());

    // injeksi brand controller
    Get.lazyPut(() => BrandController(), fenix: true);
  }
}

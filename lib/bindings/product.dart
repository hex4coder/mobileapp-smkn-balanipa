import 'package:get/get.dart';
import 'package:myapp/controllers/product.dart';

// product binding untuk mengelolah semua dependensi untuk produk

class ProductBinding implements Bindings {

  // constructor
  ProductBinding();

  @override
  void dependencies() {
    // injeksi product controller
    Get.put(ProductController());
  }
}

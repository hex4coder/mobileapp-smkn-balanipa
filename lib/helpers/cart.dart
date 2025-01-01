import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/models/product.dart';

class CartItem {
  int productId; // productId
  String productName;
  int productPrice;
  int qty;

  // otomatis dari perkalian qty * productPrice
  double total;

  String? keterangan;

  // constructor
  CartItem({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.qty,
    required this.total,
  });
}

// class untuk menjalankan fungsi cart di mobile
class CartHelper extends GetxController {
  // untuk menyimpan cart dalam local storage phone
  late GetStorage _box;

  // create key for storage box
  final String _cartKey = 'cart-items-ua';

  // list data yang akan disimpan ke storage
  final RxList<CartItem> _items = RxList.empty();

  @override
  void onInit() {
    // inisialisasi box storage
    _box = GetStorage('cart-helper');
    // load cart items from localstorage
    loadItems();
    super.onInit();
  }

  // operasi CRUD pada box
  Future<void> saveItems(List<CartItem> cartItems) async {
    await reset();
    await _box.write(_cartKey, cartItems);
    await _box.save();

    // set new items cart
    items = cartItems;
  }

  Future<void> reset() async {
    await _box.remove(_cartKey);
    await _box.erase();
  }

  // load items from cart
  Future<void> loadItems() async {
    final cartItems = _box.read<List<CartItem>>(_cartKey);
    if (cartItems != null) {
      items = cartItems;
    } else {
      items = [];
    }
  }

  // save current items in cart to storage
  Future<void> saveCurrentItems() async {
    await saveItems(items);
  }

  Future<void> addNewItemFromProduct(Product product) async {
    const defaultQty = 1;

    // create new item
    final item = CartItem(
        productId: product.id,
        productName: product.nama,
        productPrice: product.harga,
        qty: defaultQty,
        total: (product.harga * defaultQty).toDouble());

    await addNewItem(item);
  }

  // add new items to cart
  Future<void> addNewItem(CartItem item) async {
    items.add(item);
    await saveCurrentItems();
  }

  // update current item
  Future<void> updateQty(CartItem item, int newQty) async {
    item.qty = newQty;
    // update current items
    final index = items.indexOf(item);
    items.removeAt(index);
    items.insert(index, item);

    // update cart
    await saveCurrentItems();
  }

  // gettters and setters
  List<CartItem> get items => _items;
  set items(List<CartItem> newItems) => _items.assignAll(newItems);
}

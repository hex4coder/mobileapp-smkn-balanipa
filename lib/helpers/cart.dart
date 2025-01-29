import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/models/product.dart';

class CartItem {
  int productId; // productId
  String productName;
  int productPrice;
  int qty;
  int stock;
  String thumbnail;

  // otomatis dari perkalian qty * productPrice
  double total;

  String? keterangan;

  // constructor
  CartItem({
    required this.productId,
    required this.productName,
    required this.thumbnail,
    required this.productPrice,
    required this.stock,
    required this.qty,
    required this.total,
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
        stock: data['stock'],
        thumbnail: data['thumbnail'],
        productId: data['id'],
        productName: data['name'],
        productPrice: data['price'],
        qty: data['qty'],
        total: data['total'].toDouble());
  }

  Map<String, dynamic> toJSON() {
    return {
      'stock': stock,
      'id': productId,
      'name': productName,
      'price': productPrice,
      'thumbnail': thumbnail,
      'qty': qty,
      'total': qty * productPrice
    };
  }
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
    await _box.write(_cartKey, cartItems.map((i) => i.toJSON()).toList());
    await _box.save();

    await loadItems();
  }

  Future<void> reset() async {
    await _box.remove(_cartKey);
    await _box.erase();
  }

  // load items from cart
  Future<void> loadItems() async {
    final cartItems = _box.read(_cartKey);
    if (cartItems != null) {
      items =
          (cartItems as List<dynamic>).map((i) => CartItem.fromMap(i)).toList();
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
        stock: product.stok,
        thumbnail: product.thumbnail,
        productId: product.id,
        productName: product.nama,
        productPrice: product.harga,
        qty: defaultQty,
        total: (product.harga * defaultQty).toDouble());

    await addNewItem(item, stock: product.stok);
  }

  // add new items to cart
  Future<void> addNewItem(CartItem item, {int stock = 0}) async {
    bool found = false;
    int index = -1;
    int iterator = 0;
    for (var i in items) {
      if (i.productId == item.productId) {
        index = iterator;
        found = true;
        break;
      }
      iterator = iterator + 1;
    }

    if (!found) {
      // not found
      items.add(item);
      Fluttertoast.showToast(msg: 'Produk berhasil dimasukkan kekeranjang!');
    } else {
      final citem = items[index];

      int newQty = 1;

      if (citem.qty == stock) {
        newQty = stock;
        Fluttertoast.showToast(
            msg: 'Semua stok barang ini sudah ada dikeranjang');
      } else {
        newQty = citem.qty + 1;
        Fluttertoast.showToast(
            msg: 'Sudah ada $newQty produk ini di keranjang');
      }

      // found
      await updateQty(item, newQty);
    }

    await saveCurrentItems();
  }

  // update current item
  Future<void> updateQty(CartItem item, int newQty) async {
    // update current items
    int index = -1;
    int iterator = 0;
    for (var i in items) {
      if (i.productId == item.productId) {
        index = iterator;
        break;
      }
      iterator = iterator + 1;
    }

    if (index < 0) {
      return;
    }

    items[index].qty = newQty;

    // update cart
    await saveCurrentItems();
  }

  // hapus item dari cart
  Future<void> deleteItem(CartItem item) async {
    items.remove(item);
    await saveCurrentItems();
  }

  // gettters and setters
  List<CartItem> get items => _items;
  double get total {
    double tot = 0;

    for (var i in _items) {
      tot = tot + i.total;
    }

    return tot;
  }

  set items(List<CartItem> newItems) => _items.assignAll(newItems);
}

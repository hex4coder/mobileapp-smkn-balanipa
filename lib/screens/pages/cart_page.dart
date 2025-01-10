import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    Timer(const Duration(milliseconds: 100), () {
      final ch = Get.find<CartHelper>();
      ch.loadItems().then((_) {
        // UiSnackbar.success('items', 'items loaded : ${ch.items.length}');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                final ch = Get.find<CartHelper>();
                await ch.reset();
                await ch.loadItems();
                UiSnackbar.error('Trashed', 'Keranjang dikosongkan');
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
              ))
        ],
      ),
      body: GetX<CartHelper>(
          builder: (controller) => ListView.separated(
              itemBuilder: (context, index) {
                final item = controller.items[index];

                return ListTile(
                  leading: SizedBox(
                      width: 70, child: UiNetImage(pathImage: item.thumbnail)),
                  title: Text(item.productName.toUpperCase()),
                  trailing: Text(
                    ServerConfig.convertPrice(item.total.toInt()),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                  ),
                  subtitle: DefaultTextStyle(
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ServerConfig.convertPrice(item.productPrice)),
                        Container(
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.grey)
                              ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    if (item.qty < 2) {
                                      Get.dialog(AlertDialog(
                                        title: const Text("Delete?"),
                                        content: const Text(
                                            "Buang produk ini dari keranjang?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () async {
                                                final ch =
                                                    Get.find<CartHelper>();
                                                await ch.deleteItem(item);
                                                Get.back();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        'Berhasil dikeluarkan');
                                              },
                                              child: const Text(
                                                "Ya",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          TextButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text(
                                                "Tidak",
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                ),
                                              )),
                                        ],
                                      ));
                                      return;
                                    }

                                    await controller.updateQty(
                                        item, item.qty - 1);
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.grey,
                                    size: 16,
                                  )),
                              Text(item.qty.toString()),
                              IconButton(
                                  onPressed: () async {
                                    if (item.qty < item.stock) {
                                      await controller.updateQty(
                                          item, item.qty + 1);
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                    size: 16,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
              itemCount: controller.items.length)),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            "Total ",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          GetX<CartHelper>(
            builder: (controller) => Text(
                ServerConfig.convertPrice(controller.total.toInt()),
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
          )
        ],
      ),
    );
  }
}

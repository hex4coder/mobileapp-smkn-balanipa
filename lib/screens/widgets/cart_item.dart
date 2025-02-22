import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/screens/widgets/network_image.dart';
import 'package:myapp/screens/widgets/radio_text.dart';

// ignore: must_be_immutable
class CartItemWidget extends StatefulWidget {
  CartItemWidget({
    super.key,
    required this.item,
    required this.controller,
  }) {
    ua = 'ukuran${item.productId}';
  }

  final CartHelper controller;
  final CartItem item;
  String ua = 'ukuran';

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  // load
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
          width: 70, child: UiNetImage(pathImage: widget.item.thumbnail)),
      title: Text(widget.item.productName.toUpperCase()),
      trailing: Text(
        ServerConfig.convertPrice(widget.item.total.toInt()),
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: kPrimaryColor),
      ),
      subtitle: DefaultTextStyle(
        style: const TextStyle(fontSize: 12, color: Colors.grey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //

            // product price
            Text(ServerConfig.convertPrice(widget.item.productPrice)),

            SizedBox(
              height: 30,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.item.listUkuran
                    .map((u) => RadioText(
                        radioGroup: widget.ua,
                        selected: widget.item.ukuran == u,
                        value: u,
                        onChanged: (newUkuran) {
                          setState(() {
                            widget.item.ukuran = newUkuran;
                          });

                          widget.controller
                              .updateUkuran(widget.item, newUkuran);
                        }))
                    .toList(),
              ),
            ),

            const Divider(),

            // add and sub item
            Container(
              decoration: const BoxDecoration(
                  // border: Border.all(color: Colors.grey)
                  ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () async {
                        if (widget.item.qty < 2) {
                          Get.dialog(AlertDialog(
                            title: const Text("Delete?"),
                            content:
                                const Text("Buang produk ini dari keranjang?"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    final ch = Get.find<CartHelper>();
                                    await ch.deleteItem(widget.item);
                                    Get.back();
                                    Fluttertoast.showToast(
                                        msg: 'Berhasil dikeluarkan');
                                  },
                                  child: const Text(
                                    "Ya",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
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

                        await widget.controller
                            .updateQty(widget.item, widget.item.qty - 1);
                      },
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.grey,
                        size: 16,
                      )),
                  Text(widget.item.qty.toString()),
                  IconButton(
                      onPressed: () async {
                        if (widget.item.qty < widget.item.stock) {
                          await widget.controller
                              .updateQty(widget.item, widget.item.qty + 1);
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
  }
}

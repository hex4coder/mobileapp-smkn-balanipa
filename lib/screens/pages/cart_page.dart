import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/screens/checkout.dart';
import 'package:myapp/screens/widgets/empty_widget.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class CartPage extends StatefulWidget {
  const CartPage({required this.pageController, super.key});

  final PageController pageController;

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
        title: const Text("Keranjang Belanja"),
        centerTitle: true,
        actions: [
          GetX<CartHelper>(builder: (controller) {
            if (controller.items.isEmpty) {
              return Container();
            }

            return IconButton(
                onPressed: () async {
                  final ch = Get.find<CartHelper>();
                  await ch.reset();
                  await ch.loadItems();
                  UiSnackbar.error('Trashed', 'Keranjang dikosongkan');
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ));
          })
        ],
      ),
      body: GetX<CartHelper>(
        builder: (controller) => controller.items.isEmpty
            ? SizedBox.fromSize(
                size: MediaQuery.of(context).size,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const EmptyWidget(
                        title: 'Kosong',
                        description: 'Keranjang belanja kosong!'),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        iconColor: Colors.white,
                      ),
                      onPressed: () {
                        widget.pageController.animateToPage(1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      label: const Text(
                        'Belanja dulu!',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(Icons.shopping_bag),
                    )
                  ],
                ),
              )
            : ListView.separated(
                itemBuilder: (context, index) {
                  if (index == controller.items.length) {
                    return Column(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            iconColor: Colors.white,
                          ),
                          onPressed: () {
                            final AuthController authController = Get.find();
                            if (authController.isLoggedIn == false) {
                              widget.pageController.animateToPage(3,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease);
                              Fluttertoast.showToast(
                                  msg:
                                      'Anda belum login, silahkan login terlebih dahulu.');
                            } else {
                              // buka checkout page
                              Get.to(() => const CheckoutScreen());
                            }
                          },
                          icon: const Icon(Icons.card_membership),
                          label: const Text("Checkout"),
                        ),
                      ],
                    );
                  }

                  final item = controller.items[index];

                  return CartItemWidget(item: item, controller: controller,);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 20,
                  );
                },
                itemCount: controller.items.length + 1),
      ),
      floatingActionButton: GetX<CartHelper>(builder: (controller) {
        if (controller.items.isEmpty) {
          return Container();
        }
        return Row(
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
            GetX<CartHelper>(builder: (controller) {
              return Text("Rp. ${controller.total.toInt()}, -",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor));
            })
          ],
        );
      }),
    );
  }
}



class RadioText extends StatefulWidget {
  const RadioText({
    


    required this.radioGroup,
    required this.value,
    required this.onChanged,




    super.key});


  final ValueChanged<String> onChanged;
  final String radioGroup;
  final String value;



  @override
  State<RadioText> createState() => _RadioTextState();



}

class _RadioTextState extends State<RadioText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio.adaptive(value: widget.value, groupValue: widget.radioGroup, onChanged: (b) => widget.onChanged(b!))
      ],
    );
  }
}





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






  @override
  void initState() {
    

    // load list detail from server identified by product id



    // super constructor
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
          width: 70,
          child: UiNetImage(pathImage: widget.item.thumbnail)),
      title: Text(widget.item.productName.toUpperCase()),
      trailing: Text(
        ServerConfig.convertPrice(widget.item.total.toInt()),
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

            // 


            // product price
            Text(ServerConfig.convertPrice(widget.item.productPrice)),

            Row(
              children: widget.item.listUkuran.map((u) => RadioText(radioGroup: widget.ua, value: u, onChanged: (newUkuran) {
                widget.item.ukuran= newUkuran;
              })).toList(),
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
                            content: const Text(
                                "Buang produk ini dari keranjang?"),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    final ch =
                                        Get.find<CartHelper>();
                                    await ch.deleteItem(widget.item);
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
    
                        await widget.controller.updateQty(
                            widget.item, widget.item.qty - 1);
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
                          await widget.controller.updateQty(
                              widget.item, widget.item.qty + 1);
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.grey,
                        size: 16,
                      )),
    
                  //TODO: Tambahkan pemilihan ukuran produk
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

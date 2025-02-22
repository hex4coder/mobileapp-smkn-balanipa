import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';

import 'package:myapp/helpers/cart.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/screens/checkout.dart';
import 'package:myapp/screens/widgets/cart_item.dart';
import 'package:myapp/screens/widgets/empty_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({required this.pageController, super.key});

  final PageController pageController;

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final ch = Get.find<CartHelper>();

  @override
  void initState() {
    Timer(const Duration(milliseconds: 100), () {
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
                          onPressed: () async {
                            final AuthController authController = Get.find();
                            if (authController.isLoggedIn == false) {
                              widget.pageController.animateToPage(3,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease);
                              Fluttertoast.showToast(
                                  msg:
                                      'Anda belum login, silahkan login terlebih dahulu.');
                            } else {
                              // check all items
                              if (!ch.isValidForCheckout()) {
                                Fluttertoast.showToast(
                                    msg:
                                        'Pastikan anda telah memilih ukuran dengan benar!');

                                return;
                              }

                              // buka checkout page
                              Get.to(() => CheckoutScreen(
                                    pageController: widget.pageController,
                                  ));
                            }
                          },
                          icon: const Icon(Icons.card_membership),
                          label: const Text("Checkout"),
                        ),
                      ],
                    );
                  }

                  final item = controller.items[index];

                  return CartItemWidget(
                    item: item,
                    controller: controller,
                  );
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

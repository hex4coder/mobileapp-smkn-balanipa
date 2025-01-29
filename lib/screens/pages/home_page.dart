import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/category.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/screens/widgets/category_widget.dart';
import 'package:myapp/screens/widgets/empty_widget.dart';
import 'package:myapp/screens/widgets/header_row_widget.dart';
import 'package:myapp/screens/widgets/product_widget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({required this.pageController, super.key});

  final PageController pageController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // untuk membuat header widget
  Container _headerWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: kPrimaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "SMKN Balanipa",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            "Salah satu Sekolah Pusat Keunggulan",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
          TextButton.icon(
            onPressed: () async {
              // web url
              const String url = "https://smknbalanipa.sch.id";
              final uri = Uri.parse(url);
              await launchUrl(uri);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              iconColor: Colors.white,
            ),
            icon: const Icon(Icons.web),
            label: const Text("Lihat Web"),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  // inisialisasi data disini
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
    return SafeArea(
      child: Container(
        color: Colors.grey.shade100,
        height: MediaQuery.of(context).size.height * .7,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset("assets/img/logo.png"),
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            },
                            icon: const Icon(
                              Icons.shopping_cart,
                              color: kPrimaryColor,
                            ),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: GetX<CartHelper>(
                                builder: (controller) => CircleAvatar(
                                  backgroundColor: kSecondaryColor,
                                  radius: 10,
                                  child: Text(
                                    controller.items.length.toString(),
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              _headerWidget(),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderRowWidget(
                      onTap: () {},
                      title: "Kategori",
                    ),
                    SizedBox(
                      height: 150,
                      child: GetX<CategoryController>(builder: (controller) {
                        if (controller.isloading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.list.isEmpty) {
                          return const Center(
                            child: EmptyWidget(
                                title: 'No Data',
                                description:
                                    'Tidak ada data kategori yang ditemukan'),
                          );
                        }

                        return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 30,
                          ),
                          itemBuilder: (context, index) {
                            return CategoryWidget(
                              category: controller.list[index],
                              onTap: () {},
                            );
                          },
                          shrinkWrap: true,
                          itemCount: controller.list.length,
                          scrollDirection: Axis.horizontal,
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    HeaderRowWidget(
                      onTap: () {
                        Get.find<ProductController>().fetchPopularProducts(7);
                      },
                      title: "Produk Populer",
                    ),
                    SizedBox(
                      height: 300,
                      child: GetX<ProductController>(
                          autoRemove: false,
                          builder: (controller) {
                            if (controller.isLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (controller.listProduct.isEmpty) {
                              return const Center(
                                child: EmptyWidget(
                                    title: 'No Data',
                                    description:
                                        'Tidak ada data produk populer yang ditemukan'),
                              );
                            }

                            return ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                width: 20,
                              ),
                              itemBuilder: (context, index) {
                                return Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ProductWidget(
                                        product: controller.listProduct[index]),
                                    Positioned(
                                        bottom: 60,
                                        right: 10,
                                        child: GestureDetector(
                                          onTap: () async {
                                            final cartHelper =
                                                Get.find<CartHelper>();
                                            await cartHelper
                                                .addNewItemFromProduct(
                                                    controller
                                                        .listProduct[index]);
                                          },
                                          child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  color: kPrimaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: const Icon(
                                                Icons.add_shopping_cart,
                                                color: Colors.white,
                                                size: 20,
                                              )),
                                        )),
                                  ],
                                );
                              },
                              shrinkWrap: true,
                              itemCount: controller.listProduct.length,
                              scrollDirection: Axis.horizontal,
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

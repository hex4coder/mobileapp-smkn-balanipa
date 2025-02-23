import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/screens/product/detail.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final gc = Get.find<ProductController>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1), () async {
      if (mounted) {
        gc.fetchAll().then((_) {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        // title: const Text("Daftar Produk"),
        actions: [
          Obx(
            () => gc.isLoading
                ? Container()
                : IconButton(
                    onPressed: () async {
                      await gc.fetchAll();
                    },
                    icon: const Icon(Icons.refresh)),
          ),
        ],
      ),
      body: GetX<ProductController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.listProduct.isEmpty) {
            return const Center(
              child: Text("Tidak ada data"),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            itemCount: controller.listProduct.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1),
            itemBuilder: (context, index) {
              final product = controller.listProduct[index];

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final controller = Get.find<ProductController>();
                        final response =
                            await controller.fetchDetailProduct(product.id);

                        if (response == null) {
                          UiSnackbar.error(
                              'Failed', 'Failed fetch detail product');
                          return;
                        }

                        Get.to(() => DetailProduct(
                              detailProduct: response,
                            ));
                      },
                      child: Hero(
                        tag: 'product-thumbnail-${product.id}',
                        child: UiNetImage(
                          pathImage: product.thumbnail,
                          fit: BoxFit.cover,
                          size: Size(MediaQuery.of(context).size.width, 200),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 20 * 2,
                        // color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.nama.toUpperCase()),
                                Text(
                                  ServerConfig.capitalize(product.deskripsi),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            Text(
                              ServerConfig.convertPrice(product.harga),
                              style: const TextStyle(
                                fontSize: 16,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        iconColor: Colors.white,
                      ),
                      onPressed: () async {
                        final CartHelper cartHelper = Get.find<CartHelper>();
                        await cartHelper.addNewItemFromProduct(product);
                      },
                      label: const Text("Masukkan ke keranjang!"),
                      icon: const Icon(Icons.shopping_bag),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/screens/widgets/product_widget.dart';

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
    Timer(const Duration(seconds: 1), () async {
      if (mounted) {
        gc.fetchAll().then((_) {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Daftar Produk"),
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

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: controller.listProduct.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1),
              itemBuilder: (context, index) {
                final i = controller.listProduct[index];

                return ProductWidget(product: i);
              },
            ),
          );
        },
      ),
    );
  }
}

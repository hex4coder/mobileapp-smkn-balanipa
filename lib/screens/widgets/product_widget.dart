import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/screens/product/detail.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailProduct(product: product));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(
                tag: 'product-image',
                child: UiNetImage(pathImage: product.thumbnail),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.nama,
                      maxLines: 1,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(.7),
                      ),
                    ),
                    Text(
                      ServerConfig.capitalize(
                              product.deskripsi.substring(0, 30)) +
                          "...",
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.black.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
                Text(
                  ServerConfig.convertPrice(product.harga),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

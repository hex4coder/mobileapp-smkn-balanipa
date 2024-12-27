import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/models/product.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    NetworkImage(ServerConfig.getImageUrl(product.thumbnail)),
                fit: BoxFit.cover,
              ),
              // color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30),
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
                    "By : ${product.brandId}",
                    style: TextStyle(
                      fontSize: 12,
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/models/product.dart';
import 'package:get/get.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({required this.product, super.key});

  final Product product;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  // render UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: Text(widget.product.nama),
      ),
      body: SizedBox.fromSize(
        size: MediaQuery.of(context).size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Hero(
                  tag: 'product-image',
                  child: UiNetImage(
                    pathImage: widget.product.thumbnail,
                  )),
            )
          ],
        ),
      ),
    );
  }
}

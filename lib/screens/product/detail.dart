import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/product.dart';
import 'package:get/get.dart';
import 'package:myapp/screens/widgets/caresoul_indicator.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({required this.detailProduct, super.key});

  final DetailProductResponse detailProduct;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  // caresoul controller for images
  int _activeIndex = 0;
  final PageController _caresoulController = PageController(initialPage: 0);

  // render UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
        title: const Text("Detail Produk"),
      ),
      body: SizedBox.fromSize(
        size: MediaQuery.of(context).size,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _caresoulController,
                          onPageChanged: (pageIndex) => setState(() {
                            _activeIndex = pageIndex;
                          }),
                          itemBuilder: (context, index) {
                            return Hero(
                              tag:
                                  widget.detailProduct.listPhoto[index].id == -1
                                      ? 'product-thumbnail-${widget.detailProduct.product.id}'
                                      : 'product-image-$index',
                              child: UiNetImage(
                                pathImage:
                                    widget.detailProduct.listPhoto[index].foto,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                          itemCount: widget.detailProduct.listPhoto.length,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.detailProduct.listPhoto.map((item) {
                          return Row(
                            children: [
                              CaresoulIndicator(
                                isActive: widget.detailProduct.listPhoto
                                        .indexOf(item) ==
                                    _activeIndex,
                              ),
                              const SizedBox(
                                width: 4,
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.detailProduct.kategori.namaKategori,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.detailProduct.product.deskripsi,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "By : ${widget.detailProduct.brand.name}",
                  style: const TextStyle(
                    fontSize: 10,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                        Text(ServerConfig.convertPrice(widget.detailProduct.product.harga), style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,

                        ),),


                        
 
                    const SizedBox(height: 10,),
                        RowInfoIcon(
                          icon: widget.detailProduct.product.isPopular
                              ? Icons.check
                              : Icons.not_accessible,
                          text: widget.detailProduct.product.isPopular
                              ? "Populer"
                              : "Tidak Popular",
                          iconColor: widget.detailProduct.product.isPopular
                              ? Colors.green
                              : kSecondaryColor,
                        ), 
                  ],
                ),
const SizedBox(height: 20,),
                // button
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      iconColor: Colors.white,
                    ),
                    onPressed: () async {
                      // TODO: Masukkan data kedalam shopping cart
                    },
                    label: const Text("Masukkan Keranjang",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        )),
                    icon: const Icon(Icons.add_shopping_cart),
                  ),
                ),
const SizedBox(height: 20,),  
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowInfoIcon extends StatelessWidget {
  const RowInfoIcon({
    required this.icon,
    required this.text,
    this.iconColor = Colors.green,
    super.key,
  });

  final Color iconColor;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kPrimaryColor.withValues(alpha: .05),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

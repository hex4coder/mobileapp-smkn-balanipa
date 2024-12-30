import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/models/product.dart';
import 'package:get/get.dart';
import 'package:myapp/screens/widgets/caresoul_indicator.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({required this.product, super.key});

  final Product product;

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  // caresoul controller for images
  int _activeIndex = 0;
  final PageController _caresoulController = PageController(initialPage: 0);
  final ProductController _controller = Get.find<ProductController>();

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
        child: FutureBuilder<DetailProductResponse?>(
            initialData: null,
            future: _controller.fetchDetailProduct(widget.product.id),
            builder: (context, snapshot) {
              // loading indicator
              if (snapshot.connectionState != ConnectionState.done) {
                // loading progress
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // connection done, but there is an error
              if (snapshot.hasError && snapshot.error != null) {
                print("Ada error saat fetching data");
                return ErrorWidget("Fetching data error hasError true" +
                    snapshot.error!.toString());
              }

              // check value
              if (snapshot.data == null) {
                return ErrorWidget("no data found, fetch failed");
              }

              final data = snapshot.data!;

              // if thereis a data
              return SingleChildScrollView(
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
                                    tag: data.listPhoto[index].id == -1
                                        ? 'product-thumbnail'
                                        : 'product-image-$index',
                                    child: UiNetImage(
                                      pathImage: data.listPhoto[index].foto,
                                      fit: BoxFit.contain,
                                    ),
                                  );
                                },
                                itemCount: data.listPhoto.length,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: data.listPhoto.map((item) {
                                return Row(
                                  children: [
                                    CaresoulIndicator(
                                      isActive: data.listPhoto.indexOf(item) ==
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
                        data.kategori.namaKategori,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        data.product.deskripsi,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: (MediaQuery.of(context).size.width / 2) - 20,
                            child: Card(
                              elevation: 0,
                              color: kPrimaryColor.withValues(alpha: .1),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          ServerConfig.getImageUrl(
                                              data.brand.logo.isNotEmpty
                                                  ? data.brand.logo
                                                  : ServerConfig.kNoImage,
                                              externalUrl:
                                                  data.brand.logo.isEmpty)),
                                      radius: 40,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      data.brand.name,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              RowInfoIcon(
                                icon: data.product.isPopular
                                    ? Icons.check
                                    : Icons.not_accessible,
                                text: data.product.isPopular
                                    ? "Populer"
                                    : "Tidak Popular",
                                iconColor: data.product.isPopular
                                    ? Colors.green
                                    : kSecondaryColor,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
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

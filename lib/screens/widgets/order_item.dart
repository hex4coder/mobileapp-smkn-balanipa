import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/order.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/models/order.dart';
import 'package:myapp/models/order_detail.dart';

class DetailOrderWithProducts {
  final OrderDetail orderDetail;
  final DetailProductResponse detailProductResponse;

  DetailOrderWithProducts(
      {required this.orderDetail, required this.detailProductResponse});
}

class OrderItem extends StatefulWidget {
  const OrderItem({required this.order, super.key});

  final Order order;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool loading = true;
  bool productLoading = true;
  late ProductController productController;
  late OrderController orderApi;
  List<OrderDetail> listDetailsOrder = [];
  List<DetailProductResponse?> productsDetail = [];

  @override
  void initState() {
    productController = Get.find();
    orderApi = Get.find();
    orderApi.getDetailOrder(widget.order.id).then((details) async {
      setState(() {
        loading = false;
        listDetailsOrder.assignAll(details);
      });

      List<DetailProductResponse?> detailsproducts = [];
      if (details.isNotEmpty) {
        await Future.forEach(details, (detail) async {
          final data =
              await productController.fetchDetailProduct(detail.produkId);
          detailsproducts.add(data);
        });
      }

      setState(() {
        productsDetail.assignAll(detailsproducts);
        productLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: kPrimaryColor,
            width: 2,
          ),
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                      // height: 30,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Order ID : ${widget.order.id}"),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.more_horiz_outlined))
                          ],
                        ),
                      )),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                      color: Colors.transparent,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // orders infp
                          Row(
                            children: [
                              productLoading
                                  ? const CircularProgressIndicator.adaptive()
                                  : Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                ServerConfig.getImageUrl(
                                                    productsDetail[0]
                                                            ?.product
                                                            .thumbnail ??
                                                        ServerConfig.kNoImage)),
                                            fit: BoxFit.cover,
                                          ),
                                          color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
// product info
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  productLoading
                                      ? const CircularProgressIndicator
                                          .adaptive()
                                      : Text(
                                          productsDetail[0]?.product.nama ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                  Text(
                                    widget.order.tanggal.toIso8601String(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),

                              // spacer
                              const Spacer(),
                              Container(
                                decoration: BoxDecoration(
                                  color: getColorByStatus(
                                      widget.order.status.toLowerCase(),
                                      foreground: false),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  widget.order.status.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 9,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.w900,
                                    color: getColorByStatus(
                                        widget.order.status.toLowerCase(),
                                        foreground: true),
                                  ),
                                ),
                              )
                            ],
                          ),

                          const Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Total Bayar",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "Rp. ${widget.order.totalBayar}, -",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Color getColorByStatus(String lowerStatus, {bool foreground = false}) {
    Color color = Colors.amber;

    if (lowerStatus == "dibatalkan") color = Colors.red;
    if (lowerStatus == "sedang diproses") color = Colors.blue;
    if (lowerStatus == "dibatalkan") color = Colors.red;
    if (lowerStatus == "sudah dikirim") color = Colors.indigo;
    if (lowerStatus == "selesai") color = Colors.green;

    if (!foreground) color = color.withOpacity(.12);

    return color;
  }
}

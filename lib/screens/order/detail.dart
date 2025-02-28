import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/models/order.dart';
import 'package:myapp/models/order_detail.dart';
import 'package:myapp/screens/widgets/network_image.dart';
import 'package:myapp/screens/widgets/order_detail_container.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage(
      {super.key,
      required this.order,
      required this.listDetailProducts,
      required this.listOrderDetails});

  final Order order;
  final List<DetailProductResponse?> listDetailProducts;
  final List<OrderDetail> listOrderDetails;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  String userAddress = "";
  final AuthController auth = Get.find();

  @override
  void initState() {
    super.initState();

    getUserAddress();
  }

  void getUserAddress() async {
    await Future.delayed(const Duration(milliseconds: 1));

    setState(() {
      userAddress = auth.user?.address?.toAddress() ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            centerTitle: true,
            title: Text("Detail Order ID ${widget.order.id}"),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  OrderDetailContainer(
                    title: "Alamat Lengkap",
                    icon: Icons.home,
                    content: Text(
                      userAddress,
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OrderDetailContainer(
                    title: "Status Pembayaran",
                    icon: Icons.card_membership,
                    content: UiNetImage(
                      pathImage: widget.order.buktiTransfer,
                    ),
                    actionWidget: Text(widget.order.sudahTerbayar
                        ? "Terverifikasi"
                        : "Belum diverifikasi"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemBuilder: (_, index) {
              final pd = widget.listDetailProducts[index]!;
              final d = widget.listOrderDetails[index];

              return Padding(
                  padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Column(
                    children: [
                      OrderDetailContainer(
                        title: pd.product.nama,
                        icon: Icons.notes,
                        actionWidget: Container(
                          decoration: BoxDecoration(
                            color: ServerConfig.getColorByStatus(
                                widget.order.status.toLowerCase(),
                                foreground: false),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            widget.order.status.toUpperCase(),
                            style: TextStyle(
                              color: ServerConfig.getColorByStatus(
                                  widget.order.status.toLowerCase(),
                                  foreground: true),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            UiNetImage(pathImage: pd.product.thumbnail),
                          ],
                        ),
                      )
                    ],
                  ));
            },
            itemCount: widget.listOrderDetails.length,
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}

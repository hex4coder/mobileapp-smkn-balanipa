import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/controllers/order.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/models/order.dart';
import 'package:myapp/models/order_detail.dart';
import 'package:myapp/screens/widgets/alasan_pembatalan_widget.dart';
import 'package:myapp/screens/widgets/confirm_widget.dart';
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

  bool loading = false;
  final OrderController orderApi = Get.find();

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

  void cancelMyOrder() async {
    // konfirmasi
    //
    final y = await Get.dialog(const ConfirmWidget(
        title: "Batalkan",
        description: "Anda yakin ingin membatalkan pesanan ini?"));
    if (y != "yes") {
      return;
    }
    // buat alasan alasanPembatalan
    final alasanP = await Get.dialog(const AlasanPembatalanWidget());

    if (alasanP == null || alasanP.toString().isEmpty) {
      Fluttertoast.showToast(msg: "Alasan pembatalan harus ada");
      return;
    }

    setState(() {
      loading = true;
    });

    final orderId = widget.order.id;

    final cancelled = await orderApi.cancelMyOrder(
        CancelOrderRequest(orderId: orderId, alasanPembatalan: alasanP));
    setState(() {
      loading = false;
    });
    if (cancelled) {
      await orderApi.getMyOrders();
      Get.back();
      UiSnackbar.success("Deleted", "Pesanan berhasil dihapus");
    }
  }

  void deleteMyOrder() async {
    final y = await Get.dialog(const ConfirmWidget(
        title: "Delete?",
        description: "Anda yakin ingin menghapus pesanan ini?"));
    if (y != "yes") {
      return;
    }
    setState(() {
      loading = true;
    });
    final orderId = widget.order.id;

    final deleted = await orderApi.deleteMyOrders(orderId);
    setState(() {
      loading = false;
    });
    if (deleted) {
      await orderApi.getMyOrders();
      Get.back();
      UiSnackbar.success("Deleted", "Pesanan berhasil dihapus");
    }
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
                  if (widget.order.status.toLowerCase() == "dibatalkan") ...[
                    OrderDetailContainer(
                      title: "Alasan pesanan dibatalkan",
                      icon: Icons.home,
                      content: Text(
                        widget.order.alasanPembatalan ?? "",
                        style: const TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
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
                    title: "Detail Harga",
                    icon: Icons.money_rounded,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Harga Produk : Rp. ${widget.order.totalHargaProduk},-",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Total Diskon : Rp. ${widget.order.totalDiskon},-",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Total Bayar : Rp. ${widget.order.totalBayar},-",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
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
                    actionWidget: Text(
                      widget.order.sudahTerbayar
                          ? "Terverifikasi"
                          : "Belum diverifikasi",
                      style: TextStyle(
                          color: widget.order.sudahTerbayar
                              ? kPrimaryColor
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Center(
              child: Text("Produk yang Dibeli"),
            ),
          ),
          SliverList.builder(
            itemBuilder: (_, index) {
              final pd = widget.listDetailProducts[index]!;
//              final d = widget.listOrderDetails[index];

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
          if (widget.order.status.toLowerCase() == "dibatalkan") ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    deleteMyOrder();
                  },
                  label: const Text(
                    "Hapus Order",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    overlayColor: Colors.red,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
          ],
          if (widget.order.status.toLowerCase() == "baru") ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: OutlinedButton.icon(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    cancelMyOrder();
                  },
                  label: const Text(
                    "Batalkan",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    overlayColor: Colors.red,
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

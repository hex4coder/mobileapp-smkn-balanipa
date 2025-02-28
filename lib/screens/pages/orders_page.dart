import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/controllers/order.dart';
import 'package:myapp/screens/pages/account_page.dart';
import 'package:myapp/screens/widgets/order_item.dart';
import 'package:myapp/screens/widgets/order_status.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final AuthController _auth = Get.find();
  final OrderController _orderApi = Get.find();
  String currentSelectedOrderStatus = 'all';

  @override
  void didChangeDependencies() {
    readOrders();
    // call order api
    super.didChangeDependencies();
  }

  void readOrders() async {
    await _orderApi.getMyOrders();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<OrderStatus> listOrderStatus = [
      OrderStatus(text: 'Semua', icon: Icons.list, code: 'all'),
      OrderStatus(text: 'Baru', icon: Icons.note, code: 'baru'),
      OrderStatus(
          text: 'Diproses', icon: Icons.settings, code: 'sedang diproses'),
      OrderStatus(
          text: 'Dikirim', icon: Icons.fire_truck, code: 'sudah dikirim'),
      OrderStatus(
          text: 'Selesai',
          icon: Icons.check,
          code: 'selesai',
          activeColor: Colors.teal),
      OrderStatus(
          text: 'Dibatalkan',
          icon: Icons.cancel,
          code: 'dibatalkan',
          activeColor: Colors.red),
    ];

    return CustomScrollView(
      slivers: [
        // appbar
        SliverAppBar(
          title: Text("Hi, ${_auth.user?.name ?? 'Unknown'}"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.people),
              tooltip: "Informasi Akun",
            ),
            IconButton(
                onPressed: () async {
                  final AuthController authController = Get.find();
                  await authController.signout();

                  Fluttertoast.showToast(
                      msg: 'Anda telah keluar dari akun anda!');
                },
                tooltip: "Sign Out",
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ))
          ],
        ),
        // order status widgets
        SliverToBoxAdapter(
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return OrderStatusWidget(
                    onTap: () {
                      setState(() {
                        currentSelectedOrderStatus =
                            listOrderStatus[index].code;
                      });
                    },
                    text: listOrderStatus[index].text,
                    icon: listOrderStatus[index].icon,
                    activeColor: listOrderStatus[index].activeColor,
                    isSelected: listOrderStatus[index].code ==
                        currentSelectedOrderStatus,
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: listOrderStatus.length,
              ),
            ),
          ),
        ),

        // spacer
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 30,
          ),
        ),

        // order list
        SliverList.builder(
          itemBuilder: (_, index) {
            final orders = _orderApi.listOrders;

            // no data
            if (orders.isEmpty) {
              return const Center(
                child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator.adaptive()),
              );
            }

            // get current orders
            final order = orders[index];
            return OrderItem(
              order: order,
            );
          },
          itemCount:
              _orderApi.listOrders.isEmpty ? 1 : _orderApi.listOrders.length,
        )
      ],
    );
  }
}

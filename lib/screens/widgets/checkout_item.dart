import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/screens/widgets/network_image.dart';

class CheckoutItem extends StatefulWidget {
  const CheckoutItem({required this.item, super.key});

  final CartItem item;

  @override
  State<CheckoutItem> createState() => _CheckoutItemState();
}

class _CheckoutItemState extends State<CheckoutItem> {
  // text controller
  TextEditingController textEditingController = TextEditingController();
  CartHelper cartHelper = Get.find();

  @override
  void initState() {
    // read current item
    textEditingController.text = widget.item.keterangan ?? "";

    // register listener for keterangan
    textEditingController.addListener(() {
      String keterangan = textEditingController.text;

      // update keterangan
      cartHelper.updateKeterangan(widget.item, keterangan);
    });

    super.initState();
  }

  // render UI
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: UiNetImage(pathImage: widget.item.thumbnail),
      ),
      title: Text(
        widget.item.productName.toUpperCase(),
        maxLines: 1,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black87,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Text(
            "Ukuran : ${widget.item.ukuran}",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Harga : Rp. ${widget.item.productPrice.toInt()}, -",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Jumlah yang dipesan : ${widget.item.qty} pcs.",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Total Harga : Rp. ${widget.item.total.toInt()}, -.",
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: textEditingController,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.black54),
            decoration: const InputDecoration(
              hintText: "Keterangan...",
              hintStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/screens/widgets/network_image.dart';


class CheckoutItem extends StatefulWidget {
  const CheckoutItem({
    
    required this.item,
    
    super.key});



  final CartItem item;

  @override
  State<CheckoutItem> createState() => _CheckoutItemState();
}

class _CheckoutItemState extends State<CheckoutItem> {




  // text controller
  TextEditingController textEditingController = TextEditingController();



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
                                const SizedBox(height: 10,),
                                TextField(
                                  controller: textEditingController,
                                )
                              ],
                            ),
                          );
  }
}
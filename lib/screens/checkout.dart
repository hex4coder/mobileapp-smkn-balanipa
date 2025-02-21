import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/helpers/cart.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/models/promo_code.dart';
import 'package:myapp/screens/widgets/address_info.dart';
import 'package:myapp/screens/widgets/checkout_item.dart';
import 'package:myapp/screens/widgets/info_widget.dart';
import 'package:myapp/screens/widgets/photo_picker.dart';

import 'package:dio/dio.dart' as d;

enum TipePembayaran {
  cod,
  manual,
}

enum StatusKodePromo {
  belumcek,
  tidakada,
  ada,
}

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    required this.pageController,
    super.key,
  });

  final PageController pageController;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late AuthController authController;
  late CartHelper _cartHelper;
  late ApiHttp _apiHttp;
  late AuthController _authController;
  File? buktiPembayaran;

  bool loading = false;

  TipePembayaran _tipePembayaran = TipePembayaran.manual;
  final TextEditingController _promoController = TextEditingController();

  StatusKodePromo _statusKodePromo = StatusKodePromo.belumcek;
  int _diskon = 0;
  int totalAkhir = 0;
  bool _mengecekPromo = false;

  @override
  void initState() {
    // inisialisasi
    authController = Get.find();
    _cartHelper = Get.find();
    _apiHttp = Get.find();
    _authController = Get.find();

    totalAkhir = _cartHelper.total.toInt();

    // promo controller
    _promoController.addListener(() {
      if (_promoController.text.isEmpty) {
        _diskon = 0;
        totalAkhir = _cartHelper.total.toInt();

        // update UI
        setState(() {
          _statusKodePromo = StatusKodePromo.belumcek;
        });
      }
    });

    super.initState();
  }

  // fungsi untuk kirim data ke server
  void proccessCheckout() async {
    if (loading) return; // hanya bisa 1x kirim

    // validasi data
    if (buktiPembayaran == null) {
      Fluttertoast.showToast(msg: "Silahkan lampirkan bukti pembayaran anda!");
      return;
    }

    // check user login
    if (_authController.user == null) {
      Fluttertoast.showToast(msg: "Data pengguna tidak bisa diload");
      return;
    }

    // konfirmasi
    final konfirmasi = await Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi!'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Benar bahwa apa yang saya lakukan sudah benar?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ya',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor)),
            onPressed: () {
              Get.back(result: 'ya');
            },
          ),
          TextButton(
            child: const Text('Tidak',
                style: TextStyle(fontSize: 12, color: Colors.amber)),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );

    // jika di konfirmasi
    if (konfirmasi == 'ya') {
      // buat form data
      d.FormData formData = d.FormData.fromMap({
        'bukti_transfer': await d.MultipartFile.fromFile(buktiPembayaran!.path,
            filename: buktiPembayaran!.path.split("/").last),
        'total_harga_produk': _cartHelper.total.toInt().toString(),
        'total_diskon': _diskon.toInt().toString(),
        'total_bayar': totalAkhir.toInt().toString(),
      });

      // jika ada diskon maka, tambahkan kode promo
      if (_statusKodePromo == StatusKodePromo.ada) {
        formData.fields.add(MapEntry('code_promo', _promoController.text));
      }

      // sertakan user id
      final int userId = _authController.user!.id.toInt();
      formData.fields.add(MapEntry('user_id', userId.toString()));

      // proses detail pesanan berdasarkan data pada cart
      List<Map<String, dynamic>> details = [];

      // read the cart items
      final CartHelper cart = Get.find();

      // Menambahkan item dari cart kedalam field form data
      // iterasi cart item
      for (var cartItem in cart.items) {
        details.add(cartItem.toDetailJSON());
      }

      // konversi ke jsonstring sebelum penambahan ke array data
      String detailProductJSONString = jsonEncode(details);
      formData.fields.add(MapEntry('detail', detailProductJSONString));

      // proses data untuk dikirim ke server
      print(formData);
      print(formData.fields);

      setState(() {
        loading = true;
      });

      // post data to server
      final res = await _apiHttp.post('/order', formData,
          postDataType: ContentTypeRequest.multipartFormData);

      // finish

      // error
      if (res.isError) {
        Fluttertoast.showToast(msg: "Terjadi kesalahan.");
        UiSnackbar.error('Error', res.message);
        return;
      }

      // success
      await UiSnackbar.success("Berhasil", "Pesanan berhasil dibuat");
      // 1. kosongkan cart
      await _cartHelper.reset();
      // 2. tutup halaman checkout
      widget.pageController.animateToPage(4,
          duration: const Duration(milliseconds: 230), curve: Curves.linear);
      // 3. redirect ke halaman akun

      setState(() {
        loading = false;
      });
    }
  }

  // cek kode promo
  void checkPromoCode() async {
    if (_mengecekPromo) {
      return;
    }

    // cek kode promo
    String kodePromo = _promoController.text;

    // cek apakah user sudah input kode
    if (kodePromo.isEmpty) {
      Fluttertoast.showToast(msg: 'Masukkan dulu kode promo');

      return;
    }

    // buat path untuk cek kode promo
    String promoPath = "/check-promo/$kodePromo";

    // lakukan pengiriman ke server
    setState(() {
      _mengecekPromo = true;
    });

    // kita cek respon dari sercer
    final r = await _apiHttp.get(promoPath);

    // check error
    if (r.isError) {
      _diskon = 0;

      // show error
      if (r.message == _authController.tokenError) {
        await _authController.signout();
        Get.back();
        Fluttertoast.showToast(
            msg: 'Sesi anda berakhir anda harus login ulang');
      } else if (r.message.toLowerCase().contains('no record')) {
        _diskon = 0;
      }
    } else {
      final PromoCode promoCode = PromoCode.fromJson(r.data);
      _diskon = promoCode.getDiscount(_cartHelper.total.toInt()).toInt();
    }

    // set total
    setState(() {
      totalAkhir = _cartHelper.total.toInt() - _diskon;
    });

    // jika diskon ada
    if (_diskon > 0) {
      setState(() {
        _statusKodePromo = StatusKodePromo.ada;
      });
    } else {
      setState(() {
        _statusKodePromo = StatusKodePromo.tidakada;
      });
    }

    setState(() {
      _mengecekPromo = false;
    });
  }

  // render UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 227, 227, 227),
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Checkout"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                AddressWidget(authController: authController),

                // spacer
                const SizedBox(
                  height: 10,
                ),

                // total harga product
                InfoWidget(
                  title: "Total Harga Produk",
                  icon: Icons.ad_units,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._cartHelper.items.map((item) {
                        return CheckoutItem(
                          item: item,
                        );
                      }),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Rp. ${_cartHelper.total.toInt()}, -",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),

                // spacer
                const SizedBox(
                  height: 10,
                ),

                // total bayar
                InfoWidget(
                    title: 'Total Bayar',
                    icon: Icons.calculate,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        TextField(
                          controller: _promoController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Masukkan kode promo",
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 191, 0),
                              ),
                              onPressed: checkPromoCode,
                              child: const Text("Cek Promo",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  )),
                            ),
                            const SizedBox(
                              width: 25,
                            ),
                            if (_mengecekPromo) ...[
                              const SizedBox(
                                width: 25,
                                height: 25,
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  strokeWidth: 3,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (_mengecekPromo) ...[
                          const SizedBox(height: 20),
                          const Text(
                            "Mengecek promo...",
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],

                        const SizedBox(
                          height: 20,
                        ),

                        // tidak ada promo
                        if (_statusKodePromo == StatusKodePromo.tidakada) ...[
                          const Text(
                            "Kode promo tidak valid",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],

                        // kode promo ada
                        if (_statusKodePromo == StatusKodePromo.ada) ...[
                          Text(
                            "Yay, dapat diskon Rp. $_diskon, -",
                            style: const TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],

                        const SizedBox(
                          height: 20,
                        ),

                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total Bayar",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Rp. $totalAkhir, -",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: kPrimaryColor,
                              ),
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),

                // spacer
                const SizedBox(
                  height: 10,
                ),

                // type pengiriman
                InfoWidget(
                  title: "Tipe Pembayaran",
                  icon: Icons.email,
                  content: Row(
                    children: [
                      Radio.adaptive(
                          activeColor: kPrimaryColor,
                          value: TipePembayaran.manual,
                          groupValue: _tipePembayaran,
                          onChanged: (v) {
                            setState(() {
                              _tipePembayaran = TipePembayaran.manual;
                            });
                          }),
                      const Text(
                        "Transfer Manual",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // spacer
                const SizedBox(
                  height: 10,
                ),

                // transfer manual
                if (_tipePembayaran == TipePembayaran.manual) ...[
                  InfoWidget(
                    title: "Bukti Pembayaran",
                    icon: Icons.qr_code,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 400,
                          width: double.infinity,
                          child: PhotoPicker(
                            onChanged: (file) {
                              setState(() {
                                buktiPembayaran = file;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],

                // spacer
                const SizedBox(height: 20),

                // checkout button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    loading
                        ? const CircularProgressIndicator.adaptive()
                        : Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                iconColor: Colors.white,
                              ),
                              onPressed: proccessCheckout,
                              icon: const Icon(Icons.send),
                              label: const Text(
                                "Proses",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

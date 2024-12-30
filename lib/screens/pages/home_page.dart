import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/category.dart';
import 'package:myapp/controllers/product.dart';
import 'package:myapp/screens/widgets/category_widget.dart';
import 'package:myapp/screens/widgets/empty_widget.dart';
import 'package:myapp/screens/widgets/header_row_widget.dart';
import 'package:myapp/screens/widgets/product_widget.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchProductController;
  bool _isVoiceSearchClicked = false;

  // untuk membuat header widget
  Container _headerWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: kPrimaryColor, borderRadius: BorderRadius.circular(30)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 40,
          ),
          const Text(
            "SMKN Balanipa",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            "Salah satu Sekolah Pusat Keunggulan",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white54,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          _searchFieldWidget(),
        ],
      ),
    );
  }

  // untuk membuat kotak pencarian
  Stack _searchFieldWidget() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _searchProductController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Cari produk disini...",
              labelText: "Cari Produk",
              labelStyle: TextStyle(
                color: Colors.black.withOpacity(.3),
                fontSize: 14,
              ),
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(.3),
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black.withOpacity(.2),
              ),
              suffixIcon: const Icon(
                Icons.mic,
                color: kPrimaryColor,
              ),
            ),
          ),
        ),
        Positioned(
          right: 8,
          top: 8,
          child: GestureDetector(
            // onTap: () {},
            onTapDown: (d) {
              setState(() {
                _isVoiceSearchClicked = true;
              });
            },
            onTapUp: (d) {
              setState(() {
                _isVoiceSearchClicked = false;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: _isVoiceSearchClicked
                    ? kPrimaryColor.withOpacity(.2)
                    : kPrimaryColor.withOpacity(.1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // inisialisasi data disini
  @override
  void initState() {
    _searchProductController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.grey.shade100,
        padding: const EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height * .7,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _headerWidget(),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderRowWidget(
                      onTap: () {
                        Get.find<ProductController>().fetchPopularProducts(4);
                      },
                      title: "Produk Populer",
                    ),
                    SizedBox(
                      height: 200,
                      child: GetX<ProductController>(builder: (controller) {
                        if (controller.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (controller.listProduct.isEmpty) {
                          return const Center(
                            child: EmptyWidget(
                                title: 'No Data',
                                description:
                                    'Tidak ada data produk populer yang ditemukan'),
                          );
                        }

                        return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 20,
                          ),
                          itemBuilder: (context, index) {
                            return ProductWidget(
                                product: controller.listProduct[index]);
                          },
                          shrinkWrap: true,
                          itemCount: controller.listProduct.length,
                          scrollDirection: Axis.horizontal,
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    HeaderRowWidget(
                      onTap: () {},
                      title: "Kategori",
                    ),
                    SizedBox(
                      height: 100,
                      child: GetX<CategoryController>(builder: (controller) {
                        if (controller.isloading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (controller.list.isEmpty) {
                          return const Center(
                            child: EmptyWidget(
                                title: 'No Data',
                                description:
                                    'Tidak ada data kategori yang ditemukan'),
                          );
                        }

                        return ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            width: 30,
                          ),
                          itemBuilder: (context, index) {
                            return CategoryWidget(
                              category: controller.list[index],
                              onTap: () {},
                            );
                          },
                          shrinkWrap: true,
                          itemCount: controller.list.length,
                          scrollDirection: Axis.horizontal,
                        );
                      }),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

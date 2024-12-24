import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/screens/widgets/category_widget.dart';
import 'package:myapp/screens/widgets/header_row_widget.dart';
import 'package:myapp/screens/widgets/product_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchProductController;
  bool _isVoiceSearchClicked = false;

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
              suffixIcon: Icon(
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
                      onTap: () {},
                      title: "Produk Populer",
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 20,
                        ),
                        itemBuilder: (context, index) {
                          return const ProductWidget();
                        },
                        shrinkWrap: true,
                        itemCount: 2,
                        scrollDirection: Axis.horizontal,
                      ),
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
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 10,
                        ),
                        itemBuilder: (context, index) {
                          return CategoryWidget(
                            categoryPhoto: "assets/img/logo.png",
                            categoryName: "Kategori $index",
                            onTap: () {},
                          );
                        },
                        shrinkWrap: true,
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                      ),
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

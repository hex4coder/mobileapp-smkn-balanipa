import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/screens/pages/account_page.dart';
import 'package:myapp/screens/pages/cart_page.dart';
import 'package:myapp/screens/pages/home_page.dart';
import 'package:myapp/screens/pages/products_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: _currentPageIndex);
// load current user if exists
    final AuthController authController = Get.find();
    authController.initialize();

    // check user token
    authController.checkUserToken();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer?
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        pageSnapping: false,
        onPageChanged: (int pageIndex) {
          setState(() {
            _currentPageIndex = pageIndex;
          });
        },
        children: [
          HomePage(
            pageController: _pageController,
          ),
          const ProductsPage(),
          CartPage(
            pageController: _pageController,
          ),
          const AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: (int pageIndex) {
          setState(() {
            _currentPageIndex = pageIndex;
            _pageController.animateToPage(pageIndex,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut);
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.notes), label: "Produk"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: false,
        backgroundColor: Colors.blue,
        selectedIconTheme: const IconThemeData(color: kPrimaryColor),
        unselectedIconTheme: IconThemeData(color: Colors.black.withOpacity(.2)),
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.black.withOpacity(.2),
      ),
    );
  }
}

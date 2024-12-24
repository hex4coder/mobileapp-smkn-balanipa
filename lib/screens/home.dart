import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/screens/pages/home_page.dart';

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
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int pageIndex) {
          setState(() {
            _currentPageIndex = pageIndex;
          });
        },
        children: [
          HomePage(),
          Container(
            color: kPrimaryColor,
          ),
          Container(
            color: kSecondaryColor,
          ),
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
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: "Produk"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Akun"),
        ],
        selectedIconTheme: IconThemeData(color: kPrimaryColor),
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

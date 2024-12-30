import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/bindings/product.dart';
import 'package:myapp/bindings/root.dart';
import 'package:myapp/helpers/api_token.dart';
import 'package:myapp/screens/home.dart';
import 'package:myapp/screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiTokenHelper.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mobile App - SMKN Balanipa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),

      // konfigurasi bindings dan screen
      initialRoute: '/',
      initialBinding: RootBinding(),
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomeScreen(),
          binding: ProductBinding(),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/helpers/api_token.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/helpers/user_helper.dart';
import 'package:myapp/models/user.dart';
import 'package:myapp/screens/pages/register_page.dart';
import 'package:myapp/screens/widgets/order_status.dart';

class OrderStatus {
  String text;
  IconData icon;
  String code;
  Color activeColor;
  OrderStatus(
      {required this.text,
      required this.icon,
      required this.code,
      this.activeColor = kPrimaryColor});
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late GlobalKey<FormBuilderState> _fbKey;
  String currentSelectedOrderStatus = 'all';

  late ApiTokenHelper _apiTokenHelper;
  late UserHelper _userHelper;

  @override
  void initState() {
    _fbKey = GlobalKey<FormBuilderState>();

    _apiTokenHelper = Get.find();
    _userHelper = Get.find();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetX<AuthController>(builder: (controller) {
          if (controller.isLoggedIn) return _signedUser(controller.user!);

          return _notSignedUser();
        }),
      ),
    );
  }

  Widget _notSignedUser() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FormBuilder(
          key: _fbKey,
          autovalidateMode: AutovalidateMode.always,
          initialValue: LoginUserRequest(
                  email: 'customer1@gmail.com', password: '12345678')
              .toMap(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: kPrimaryColor,
                child: Icon(
                  Icons.person_add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Autentikasi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const Text(
                "Silahkan masukkan ID anda dengan benar",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(
                height: 20,
              ),
              FormBuilderTextField(
                name: 'email',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Wajib diisi"),
                  FormBuilderValidators.email(errorText: "Email tidak valid"),
                ]),
                decoration: const InputDecoration(
                  icon: Icon(Icons.email),
                  label: Text("Email"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FormBuilderTextField(
                name: 'password',
                obscureText: true,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(errorText: "Wajib diisi"),
                  FormBuilderValidators.minLength(8,
                      errorText: "Minimal 8 karakter")
                ]),
                decoration: const InputDecoration(
                  icon: Icon(Icons.lock),
                  label: Text("Password"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GetX<AuthController>(builder: (auth) {
                if (auth.isloading) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }

                return ElevatedButton.icon(
                  onPressed: () async {
                    if (_fbKey.currentState!
                        .saveAndValidate(autoScrollWhenFocusOnInvalid: true)) {
                      // get the values from this form
                      final values = _fbKey.currentState!.value;
                      final req = LoginUserRequest.fromMap(values);

                      // send request to server
                      final regSuccess = await auth.login(req);

                      if (regSuccess) {
                        UiSnackbar.success('Signed', 'Berhasil login');
                      }
                    }
                  },
                  icon: const Icon(Icons.person_2),
                  label: const Text(
                    "Login",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    iconColor: Colors.white,
                  ),
                );
              }),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Belum memiliki akun?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const RegisterPage());
                      },
                      child: const Text(
                        "Register disini",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: kPrimaryColor),
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signedUser(User user) {
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
          title: Text("Hi, ${user.name}"),
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
        // order
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

        // order list
      ],
    );
  }
}

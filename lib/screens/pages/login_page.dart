import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/helpers/ui_snackbar.dart';
import 'package:myapp/screens/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late GlobalKey<FormBuilderState> _fbKey;

  @override
  void initState() {
    _fbKey = GlobalKey<FormBuilderState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/helpers/ui_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late GlobalKey<FormBuilderState> _fbKey;

  @override
  void initState() {
    _fbKey = GlobalKey<FormBuilderState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Registrasi Akun"),
      ),
      body: FormBuilder(
        key: _fbKey,
        autovalidateMode: AutovalidateMode.always,
        initialValue: RegisterUserRequest(
                name: 'Customer01',
                email: 'customer1@gmail.com',
                password: '12345678',
                jalan: 'Jalan Poros Luyo',
                dusun: 'Mapilli Barat',
                desa: 'Mapilli Barat',
                kecamatan: 'Luyo',
                kota: 'Polewali Mandar',
                provinsi: 'Sulawesi Barat',
                nomorhp: '082271413360',
                kodepos: '91353')
            .toMap(),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const Text(
              "Identitas Diri",
              style: TextStyle(fontSize: 14, color: kPrimaryColor),
            ),
            const SizedBox(
              height: 10,
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
            FormBuilderTextField(
              name: 'name',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
                FormBuilderValidators.minLength(3,
                    errorText: "Panjang nama tidak valid")
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                label: Text("Nama"),
              ),
            ),
            FormBuilderTextField(
              name: 'nomorhp',
              keyboardType: TextInputType.phone,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
                FormBuilderValidators.numeric(errorText: "Harus angka"),
                FormBuilderValidators.minLength(10,
                    errorText: "Panjang tidak valid")
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.phone),
                label: Text("Nomor HP"),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Alamat Lengkap Anda",
              style: TextStyle(fontSize: 14, color: kPrimaryColor),
            ),
            const SizedBox(
              height: 10,
            ),
            FormBuilderTextField(
              name: 'jalan',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.home),
                label: Text("Jalan"),
              ),
            ),
            FormBuilderTextField(
              name: 'dusun',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.home_filled),
                label: Text("Dusun"),
              ),
            ),
            FormBuilderTextField(
              name: 'desa',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.note),
                label: Text("Desa"),
              ),
            ),
            FormBuilderTextField(
              name: 'kecamatan',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.note),
                label: Text("Kecamatan"),
              ),
            ),
            FormBuilderTextField(
              name: 'kota',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.note),
                label: Text("Kota"),
              ),
            ),
            FormBuilderTextField(
              name: 'provinsi',
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.note),
                label: Text("Provinsi"),
              ),
            ),
            FormBuilderTextField(
              name: 'kodepos',
              keyboardType: TextInputType.number,
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Wajib diisi"),
                FormBuilderValidators.numeric(errorText: "Harus angka"),
                FormBuilderValidators.minLength(5,
                    errorText: "Kode pos tidak valid")
              ]),
              decoration: const InputDecoration(
                icon: Icon(Icons.note_alt),
                label: Text("Kode Pos"),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            GetX<AuthController>(builder: (auth) {
              if (auth.isloading) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: kPrimaryColor,
                  iconColor: Colors.white,
                ),
                onPressed: () async {
                  if (_fbKey.currentState!
                      .saveAndValidate(autoScrollWhenFocusOnInvalid: true)) {
                    // get the values from this form
                    final values = _fbKey.currentState!.value;
                    final req = RegisterUserRequest.fromMap(values);

                    // send request to server
                    final regSuccess = await auth.register(req);

                    if (regSuccess) {
                      UiSnackbar.success('Registered',
                          'Registrasi akun berhasil, silahkan login!');
                      _fbKey.currentState!.reset();
                    }
                  }
                },
                label: const Text("Register"),
                icon: const Icon(Icons.person_add),
              );
            }),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

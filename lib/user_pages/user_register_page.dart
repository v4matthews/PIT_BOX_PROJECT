import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/api_service.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final nomortlpnController = TextEditingController();
  final kotaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  String? selectedValue;
  List<String> regionList = [];

  @override
  void initState() {
    super.initState();
    fetchRegionData();
  }

  // Sign In Method
  void registerPage(BuildContext context) async {
    try {
      final result = await ApiService.registerUser(
        username: usernameController.text,
        email: emailController.text,
        nomorTelepon: nomortlpnController.text,
        kota: kotaController.text,
        password: passwordController.text,
        confirmPassword: confirmpasswordController.text,
      );

      if (result == true) {
        // Navigasi ke halaman login setelah sukses registrasi
        await ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.success,
            title: "Registrasi Berhasil",
            // text: "Silahkan melakukan login",
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      // Menampilkan error jika gagal registrasi
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Gagal Registrasi'),
          content: Text(e.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<bool> cekUsername(BuildContext context) async {
    try {
      final result = await ApiService.cekUsername(
        username: usernameController.text,
      );

      if (result == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> cekEmail(BuildContext context) async {
    try {
      final result = await ApiService.getEmail(
        email: emailController.text,
      );

      if (result == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> fetchRegionData() async {
    try {
      final result = await ApiService.dataRegion();
      setState(() {
        regionList =
            result.map<String>((region) => region['name'] as String).toList();
      });
    } catch (e) {
      // Menampilkan pesan error jika gagal memuat data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data region: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth * 0.8;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Welcome Text
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register Page',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 15),

              // Username textfield
              MyTextField(
                controller: usernameController,
                width: width,
                hintText: 'Username',
                obScureText: false,
              ),

              // UsernameTextField(
              //   controller: usernameController,
              //   width: width,
              //   hintText: 'Username',
              //   obScureText: false,
              //   onChanged: (username) {
              //     // Memanggil cekUsername setiap kali teks berubah
              //     if (username.isNotEmpty) {
              //       cekUsername(context);
              //     }
              //   },
              // ),

              const SizedBox(height: 15),

              // Email textfield
              EmailTextField(
                controller: emailController,
                width: width,
                hintText: 'Email',
                obScureText: false,
              ),

              const SizedBox(height: 15),

              // Nomor Telepon textfield
              NumberTextField(
                controller: nomortlpnController,
                width: width,
                hintText: 'Nomor Telepon',
                obScureText: false,
              ),

              const SizedBox(height: 15),

              // // Kota textfield
              // MyTextField(
              //   controller: kotaController,
              //   width: width,
              //   hintText: 'Kota',
              //   obScureText: false,
              // ),

              MyDropdown(
                hintText: "Pilih Kota",
                selectedValue: selectedValue,
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue;
                  });
                },
                items: regionList, // Data dari API
              ),

              const SizedBox(height: 15),

              // Password textfield
              PasswordField(
                controller: passwordController,
                width: width,
                hintText: 'Password',
              ),

              const SizedBox(height: 15),

              // Confirm Password textfield
              PasswordField(
                controller: confirmpasswordController,
                width: width,
                hintText: 'Password',
              ),

              const SizedBox(height: 20),

              // Sign in Button
              MyButton(
                width: width,
                label: "REGISTER",
                ontap: () async {
                  // Panggil cekUsername terlebih dahulu
                  bool isUsernameValid = await cekUsername(context);
                  bool isEmailValid = await cekEmail(context);
                  // Jika cekUsername berhasil, lanjutkan proses registrasi
                  if (isUsernameValid) {
                    if (isEmailValid) {
                      registerPage(context);
                    } else {
                      await ArtSweetAlert.show(
                        context: context,
                        artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.danger,
                          // title: "Username sudah digunakan",
                          text: "Email sudah digunakan",
                        ),
                      );
                    }
                  } else {
                    await ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                        type: ArtSweetAlertType.danger,
                        // title: "Username sudah digunakan",
                        text: "Username sudah digunakan",
                      ),
                    );
                    // Menangani kasus ketika cekUsername gagal (misalnya, tampilkan pesan error)
                    // showError("Username sudah digunakan!");
                  }
                },
              ),

              const SizedBox(height: 25),

              // Register Button
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width - width) /
                      2, // Padding dinamis agar sejajar
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Sudah memiliki akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke LoginPage
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          // decoration: TextDecoration.underline,
                          // decorationColor: Colors.blue
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

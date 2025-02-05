import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final namaUserController = TextEditingController();
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
      // Validasi selectedValue sebelum digunakan
      // Validasi input
      if (usernameController.text.isEmpty) {
        throw Exception('Username belum diisi');
      }
      if (namaUserController.text.isEmpty) {
        throw Exception('Nama belum diisi');
      }
      if (emailController.text.isEmpty) {
        throw Exception('Email belum diisi');
      }
      if (nomortlpnController.text.isEmpty) {
        throw Exception('Nomor telepon belum diisi');
      }
      if (selectedValue == null || selectedValue!.isEmpty) {
        throw Exception('Kota belum dipilih');
      }
      if (passwordController.text.isEmpty) {
        throw Exception('Password belum diisi');
      }
      if (confirmpasswordController.text.isEmpty) {
        throw Exception('Konfirmasi password belum diisi');
      }
      final result = await ApiService.registerUser(
        username: usernameController.text,
        nama: namaUserController.text,
        email: emailController.text,
        nomorTelepon: nomortlpnController.text,
        kota: selectedValue!,
        password: passwordController.text,
        confirmPassword: confirmpasswordController.text,
      );

      if (result == true) {
        showCustomDialog(
            context: context,
            isSuccess: true,
            title: 'Registrasi Berhasil',
            message: Text('Akun berhasil dibuat, silahkan login'),
            routeName: '/login');
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Registrasi Gagal',
          message: Text(e.toString()),
          routeName: '/login');
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
    final isSmallScreen = screenWidth < 600; // Responsivitas
    final width = screenWidth * (isSmallScreen ? 0.7 : 0.6);

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Welcome Text
                Text(
                  'Register Page',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: isSmallScreen ? 24 : 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // Username textfield
                MyTextField(
                  controller: usernameController,
                  width: width,
                  hintText: 'Username',
                  obScureText: false,
                ),

                const SizedBox(height: 15),

                // Username textfield
                MyTextField(
                  controller: namaUserController,
                  width: width,
                  hintText: 'Nama',
                  obScureText: false,
                ),

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

                // Dropdown for Kota
                AssetDropdown(
                  hintText: "Pilih Kota",
                  selectedValue: selectedValue,
                  width: width,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  items: regionList,
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
                  hintText: 'Konfirmasi Password',
                ),

                const SizedBox(height: 25),

                // Register Button
                MyButton(
                  width: width,
                  label: "REGISTER",
                  ontap: () async {
                    // Panggil cekUsername terlebih dahulu

                    bool isEmailValid = await cekEmail(context);
                    bool isUsernameValid = await cekUsername(context);

                    if (!isUsernameValid) {
                      showCustomDialog(
                        context: context,
                        isSuccess: false,
                        title: 'Registrasi Gagal',
                        message: Text('Username sudah digunakan'),
                        routeName: '/login',
                      );
                    } else if (!isEmailValid) {
                      showCustomDialog(
                        context: context,
                        isSuccess: false,
                        title: 'Registrasi Gagal',
                        message: Text('Email sudah digunakan'),
                        routeName: '/login',
                      );
                    } else {
                      registerPage(context);
                    }
                  },
                ),

                const SizedBox(height: 20),

                // Navigate to Login Page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah memiliki akun?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

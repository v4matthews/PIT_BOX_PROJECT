import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:pit_box/session_service.dart';

class UserUpdateProfile extends StatefulWidget {
  UserUpdateProfile({super.key});

  @override
  _UserUpdateProfileState createState() => _UserUpdateProfileState();
}

class _UserUpdateProfileState extends State<UserUpdateProfile> {
  final usernameController = TextEditingController();
  final namaUserController = TextEditingController();
  final emailController = TextEditingController();
  final nomortlpnController = TextEditingController();
  final kotaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  String? selectedValue;
  List<String> regionList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true; // Tampilkan loading
    });

    try {
      await fetchRegionData();
      await _loadUserData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    } finally {
      setState(() {
        isLoading = false; // Sembunyikan loading
      });
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
      throw Exception('Gagal memuat data region: $e');
    }
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await SessionService.getUserData();
      setState(() {
        usernameController.text = userData['username'] ?? '';
        namaUserController.text = userData['nama_user'] ?? '';
        emailController.text = userData['email_user'] ?? '';
        nomortlpnController.text = userData['tlpn_user'] ?? '';
        selectedValue = userData['kota_user'] ?? '';
      });
    } catch (e) {
      throw Exception('Gagal memuat data pengguna: $e');
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (usernameController.text.isEmpty) {
        throw Exception('Username belum diisi');
      }
      if (namaUserController.text.isEmpty) {
        throw Exception('Nama belum diisi');
      }
      if (emailController.text.isEmpty || !emailController.text.contains('@')) {
        throw Exception('Email tidak valid');
      }
      if (nomortlpnController.text.isEmpty) {
        throw Exception('Nomor telepon belum diisi');
      }
      if (selectedValue == null || selectedValue!.isEmpty) {
        throw Exception('Kota belum dipilih');
      }
      if (passwordController.text.isNotEmpty &&
          passwordController.text.length < 6) {
        throw Exception('Password minimal 6 karakter');
      }
      if (passwordController.text != confirmpasswordController.text) {
        throw Exception('Password dan konfirmasi password tidak sama');
      }

      final userData = await SessionService.getUserData();
      final result = await ApiService.updateUser(
        idUser: userData['id_user']!,
        username: usernameController.text,
        nama: namaUserController.text,
        email: emailController.text,
        nomorTelepon: nomortlpnController.text,
        kota: selectedValue!,
      );

      if (result == true) {
        showCustomDialog(
            context: context,
            isSuccess: true,
            title: 'Update Berhasil',
            message: Text('Profil Anda berhasil diperbarui.'),
            routeName: '/home');
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Update Gagal',
          message: Text(e.toString().replaceFirst('Exception: ', '')),
          routeName: '/home');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.8;

    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Layer 1: Background Biru
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.jpg'), // Path to your image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Layer 2: Layer dengan 60% dari ukuran layar, rounded 50px, dan berwarna putih
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(), // Tampilkan loading
                      )
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              'Update Profile',
                              style: TextStyle(
                                color: AppColors.primaryText,
                                fontSize: isSmallScreen ? 35 : 35,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 15),

                            // Sub Title Text
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.1),
                              child: Text(
                                'Pastikan data yang Anda masukkan benar untuk mempermudah proses pendataan perlombaan.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.primaryText,
                                  fontSize: isSmallScreen ? 16 : 22,
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            MyTextField(
                              controller: namaUserController,
                              width: width,
                              hintText: 'Nama',
                              obScureText: false,
                            ),
                            const SizedBox(height: 15),
                            EmailTextField(
                              controller: emailController,
                              width: width,
                              hintText: 'Email',
                              obScureText: false,
                            ),
                            const SizedBox(height: 15),
                            NumberTextField(
                              controller: nomortlpnController,
                              width: width,
                              hintText: 'Nomor Telepon',
                              obScureText: false,
                            ),
                            const SizedBox(height: 15),
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
                            const SizedBox(height: 30),

                            isLoading
                                ? CircularProgressIndicator()
                                : MyLoadingButton(
                                    label: "UPDATE",
                                    width: width,
                                    onTap: () async {
                                      await updateProfile(context);
                                    },
                                  ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                // Navigate to the '/profile' page when the row is tapped
                                Navigator.pushNamed(context, '/home');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Kembali ke home? ',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: isSmallScreen ? 16 : 22,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Kembali',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400,
                                      fontSize: isSmallScreen ? 16 : 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:pit_box/components/asset_alert.dart';

class OrganizerUpdatePassword extends StatefulWidget {
  @override
  _OrganizerUpdatePasswordState createState() =>
      _OrganizerUpdatePasswordState();
}

class _OrganizerUpdatePasswordState extends State<OrganizerUpdatePassword> {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;

  Future<void> updatePassword(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (currentPasswordController.text.isEmpty) {
        throw Exception('Password saat ini belum diisi');
      }
      if (newPasswordController.text.isEmpty) {
        throw Exception('Password baru belum diisi');
      }
      if (newPasswordController.text.length < 6) {
        throw Exception('Password baru minimal 6 karakter');
      }
      if (newPasswordController.text != confirmPasswordController.text) {
        throw Exception('Password baru dan konfirmasi password tidak sama');
      }

      final userData = await SessionService.getUserData();
      final result = await ApiService.updatePassword(
        idUser: userData['id_user']!,
        currentPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
      );

      if (result == true) {
        showCustomDialog(
            context: context,
            isSuccess: true,
            title: 'Update Password Berhasil',
            message: Text('Password Anda berhasil diperbarui.'),
            routeName: '/home');
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Gagal memperbarui password',
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
              height: MediaQuery.of(context).size.height * 0.825,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Organizer Update Password',
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
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                        child: Text(
                          'Pastikan password baru Anda aman dan mudah diingat.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontSize: isSmallScreen ? 16 : 22,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      PasswordField(
                        controller: currentPasswordController,
                        width: width,
                        hintText: 'Password Saat Ini',
                      ),
                      const SizedBox(height: 15),
                      PasswordField(
                        controller: newPasswordController,
                        width: width,
                        hintText: 'Password Baru',
                      ),
                      const SizedBox(height: 15),
                      PasswordField(
                        controller: confirmPasswordController,
                        width: width,
                        hintText: 'Konfirmasi Password Baru',
                      ),
                      const SizedBox(height: 40),
                      isLoading
                          ? CircularProgressIndicator()
                          : MyLoadingButton(
                              label: "UPDATE",
                              width: width,
                              onTap: () async {
                                await updatePassword(context);
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

import 'package:flutter/material.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_textarea.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_disabled.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:pit_box/session_service.dart';

class OrganizerUpdateProfile extends StatefulWidget {
  @override
  _OrganizerUpdateProfileState createState() => _OrganizerUpdateProfileState();
}

class _OrganizerUpdateProfileState extends State<OrganizerUpdateProfile> {
  final namaOrganizerController = TextEditingController();
  final emailController = TextEditingController();
  final nomortlpnController = TextEditingController();
  final kotaController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final alamatController = TextEditingController();
  String? selectedValue;
  List<String> regionList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    try {
      await fetchRegionData();
      await _loadOrganizerData();
    } catch (e) {
      _showSnackBar('Gagal memuat data: $e');
    } finally {
      setState(() => isLoading = false);
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

  Future<void> _loadOrganizerData() async {
    try {
      final organizerData = await SessionService.getOrganizerData();
      setState(() {
        namaOrganizerController.text = organizerData['nama_organizer'] ?? '';
        emailController.text = organizerData['email_organizer'] ?? '';
        nomortlpnController.text = organizerData['tlpn_organizer'] ?? '';
        selectedValue = organizerData['kota_organizer'] ?? '';
        alamatController.text = organizerData['alamat_organizer'] ?? '';
      });
    } catch (e) {
      throw Exception('Gagal memuat data pengguna: $e');
    }
  }

  Future<void> updateProfile(BuildContext context) async {
    setState(() => isLoading = true);
    try {
      _validateInputs();
      final organizerData = await SessionService.getOrganizerData();
      final result = await ApiService.updateOrganizer(
        idOrganizer: organizerData['id_organizer']!,
        nama: namaOrganizerController.text,
        email: emailController.text,
        nomorTelepon: nomortlpnController.text,
        kota: selectedValue!,
        alamat: alamatController.text,
      );

      if (result == true) {
        _showCustomDialog(
          context,
          true,
          'Update Berhasil',
          'Profil Anda berhasil diperbarui.',
        );
      }
    } catch (e) {
      _showCustomDialog(
        context,
        false,
        'Update Gagal',
        e.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _validateInputs() {
    if (namaOrganizerController.text.isEmpty) {
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
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCustomDialog(
      BuildContext context, bool isSuccess, String title, String message) {
    showCustomDialog(
      context: context,
      isSuccess: isSuccess,
      title: title,
      message: Text(message),
      routeName: '/homeOrganizer',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundSecondary,
      body: Stack(
        children: [
          _buildBackground(),
          _buildFormContainer(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFormContainer(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.8;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
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
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildTitle(isSmallScreen),
                      const SizedBox(height: 15),
                      _buildSubtitle(screenWidth, isSmallScreen),
                      const SizedBox(height: 30),
                      _buildFormFields(width),
                      const SizedBox(height: 30),
                      _buildUpdateButton(width),
                      const SizedBox(height: 30),
                      _buildBackToHomeLink(isSmallScreen),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTitle(bool isSmallScreen) {
    return Text(
      'Organizer Update Profile',
      style: TextStyle(
        color: AppColors.primaryText,
        fontSize: isSmallScreen ? 35 : 35,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(double screenWidth, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
      child: Text(
        'Pastikan data yang Anda masukkan benar untuk mempermudah proses pembuatan event.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: isSmallScreen ? 16 : 22,
        ),
      ),
    );
  }

  Widget _buildFormFields(double width) {
    return Column(
      children: [
        MyDisabledTextfield(
          controller: emailController,
          width: width,
          hintText: 'Email',
          obScureText: false,
        ),
        const SizedBox(height: 15),
        MyTextField(
          controller: namaOrganizerController,
          width: width,
          hintText: 'Nama',
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
        const SizedBox(height: 15),
        MyTextArea(
            controller: alamatController,
            hintText: "Alamat Lengkap",
            width: width,
            maxLines: 3,
            obScureText: false)
      ],
    );
  }

  Widget _buildUpdateButton(double width) {
    return isLoading
        ? CircularProgressIndicator()
        : MyLoadingButton(
            label: "UPDATE",
            width: width,
            onTap: () async {
              await updateProfile(context);
            },
          );
  }

  Widget _buildBackToHomeLink(bool isSmallScreen) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/homeOrganizer');
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
    );
  }
}

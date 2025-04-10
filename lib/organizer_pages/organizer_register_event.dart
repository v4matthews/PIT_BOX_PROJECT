import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_datepicker.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/components/asset_textarea.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/components/asset_textfield_price.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/components/assset_button_loading.dart';
import 'package:http/http.dart' as http;

class OrganizerRegisterEvent extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<OrganizerRegisterEvent> {
  // Pertahankan semua controller dan variabel state yang ada
  final TextEditingController namaEventController = TextEditingController();
  final TextEditingController waktuController = TextEditingController();
  final TextEditingController htmController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  String? selectedValue;
  String? kategoriController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<String> regionList = [];
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    fetchRegionData();
  }

  // Pertahankan method fetchRegionData tanpa perubahan
  Future<void> fetchRegionData() async {
    try {
      final result = await ApiService.dataRegion();
      setState(() {
        regionList =
            result.map<String>((region) => region['name'] as String).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data region: $e')),
      );
    }
  }

  // Pertahankan method pickImage tanpa perubahan
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  // Pertahankan method pickTime tanpa perubahan
  Future<void> pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        waktuController.text = picked.format(context);
      });
    }
  }

  // Pertahankan method insertEvent tanpa perubahan struktural
  Future<void> _insertEvent(BuildContext context) async {
    try {
      // Validasi input
      if (namaEventController.text.isEmpty) throw Exception('Nama belum diisi');
      if (kategoriController == null) throw Exception('Kategori belum diisi');
      if (htmController.text.isEmpty) throw Exception('HTM belum diisi');
      if (tanggalController.text.isEmpty)
        throw Exception('Tanggal belum dipilih');
      if (selectedValue == null || selectedValue!.isEmpty)
        throw Exception('Kota belum dipilih');
      if (alamatController.text.isEmpty) throw Exception('Alamat belum diisi');
      if (deskripsiController.text.isEmpty)
        throw Exception('Deskripsi belum diisi');
      if (selectedImage == null) throw Exception('Foto belum dipilih');

      // Upload gambar terlebih dahulu
      final String imageId = await ApiService.uploadImage(selectedImage!);

      // Simpan data event ke database
      final result = await ApiService.insertEvent(
        idOrganizer: '67f33da629552a8012994ff7',
        nama: namaEventController.text,
        kategori: kategoriController!,
        htm: htmController.text.replaceAll('.', '').replaceAll('Rp', '').trim(),
        kota: selectedValue!,
        tanggal: tanggalController.text,
        alamat: alamatController.text,
        deskripsi: deskripsiController.text,
        waktu: waktuController.text,
        image: imageId, // Gunakan fileId dari gambar
      );

      if (result == true) {
        showCustomDialog(
          context: context,
          isSuccess: true,
          title: 'Registrasi Event Berhasil',
          message: Text('Event anda telah terdaftar'),
          routeName: '/insertRace',
        );
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        isSuccess: false,
        title: 'Registrasi Event Gagal',
        message: Text(e.toString()),
        routeName: '/insertRace',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Pertahankan logika responsive yang ada
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            // Tambahkan padding vertikal saja
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pertahankan semua widget children yang ada
                SizedBox(height: 8), // Dipertahankan
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    width: width,
                    height: width * 4 / 3,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Klik untuk memilih foto',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pilih foto brosur event Anda! Pastikan gambar memiliki rasio 4:3 untuk hasil terbaik.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MyTextField(
                  controller: namaEventController,
                  width: width,
                  hintText: 'Nama Event',
                  obScureText: false,
                ),
                SizedBox(height: 20),
                AssetDropdown(
                  hintText: "Kategori Event",
                  width: width,
                  items: [
                    'STO',
                    'DAMPER DASH',
                    'DAMPER TUNE',
                    'STB',
                    'STB UP',
                    'SLOOP',
                    'NASCAR',
                  ],
                  selectedValue: kategoriController,
                  onChanged: (value) {
                    setState(() {
                      kategoriController = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                PriceTextField(
                  controller: htmController,
                  width: width,
                  hintText: 'HTM Event',
                  obScureText: false,
                ),
                SizedBox(height: 20),
                MyDateField(
                  controller: tanggalController,
                  width: width,
                  hintText: "Tanggal Event",
                  selectedDate: selectedDate,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(date);
                      tanggalController.text = formattedDate;
                    });
                  },
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: pickTime,
                  child: AbsorbPointer(
                    child: MyTextField(
                      controller: waktuController,
                      width: width,
                      hintText: 'Waktu Event',
                      obScureText: false,
                      suffixIcon: Icons.access_time,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                AssetDropdown(
                  hintText: "Pilih Kota",
                  selectedValue: selectedValue,
                  width: width,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  },
                  items: regionList.isNotEmpty ? regionList : ['Memuat...'],
                ),
                SizedBox(height: 20),
                MyTextArea(
                  controller: alamatController,
                  hintText: "Alamat Lengkap Event",
                  obScureText: false,
                  width: width,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 20),
                MyTextArea(
                  controller: deskripsiController,
                  hintText: "Deskripsi Event",
                  obScureText: false,
                  width: width,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                SizedBox(height: 24),
                MyLoadingButton(
                  label: "Tambah Event",
                  width: width,
                  onTap: () async {
                    await _insertEvent(context);
                  },
                ),
                // MyButton(
                //   width: width,
                //   label: "REGISTER",
                //   ontap: () async {
                //     insertEvent(context);
                //   },
                // ),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Pertahankan method _buildAppBar tanpa perubahan
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        'Tambah Pertandingan',
        style: TextStyle(
          color: AppColors.whiteText,
          fontSize: 18,
          fontFamily: 'OpenSans',
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.whiteText),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button_login.dart';
import 'package:pit_box/components/asset_datepicker.dart';
import 'package:pit_box/components/asset_dropdown.dart';
import 'package:pit_box/components/asset_textarea.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_textfield_password.dart';
import 'package:pit_box/components/asset_textfield_email.dart';
import 'package:pit_box/components/asset_textfield_number.dart';
import 'package:pit_box/api_service.dart';
import 'package:intl/intl.dart';

class OrganizerRegisterEvent extends StatefulWidget {
  OrganizerRegisterEvent({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<OrganizerRegisterEvent> {
  final TextEditingController namaEventController = TextEditingController();
  // TextEditingController kategoriController = TextEditingController();
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

  @override
  void initState() {
    super.initState();
    fetchRegionData();
  }

  // Sign In Method
  void insertEvent(BuildContext context) async {
    try {
      if (namaEventController.text.isEmpty) {
        throw Exception('Nama belum diisi');
      }
      if (kategoriController == null) {
        throw Exception('Kategori belum diisi');
      }
      if (htmController.text.isEmpty) {
        throw Exception('HTM belum diisi');
      }
      if (tanggalController.text.isEmpty) {
        throw Exception('Tanggal belum dipilih');
      }
      if (selectedValue == null || selectedValue!.isEmpty) {
        throw Exception('Kota belum dipilih');
      }
      if (alamatController.text.isEmpty) {
        throw Exception('Alamat belum diisi');
      }
      if (deskripsiController.text.isEmpty) {
        throw Exception('Deskripsi belum diisi');
      }

      final result = await ApiService.insertEvent(
          nama: namaEventController.text,
          kategori: kategoriController!,
          htm: htmController.text,
          kota: selectedValue!,
          tanggal: tanggalController.text,
          alamat: alamatController.text,
          deskripsi: deskripsiController.text,
          waktu: waktuController.text);

      if (result == true) {
        showCustomDialog(
            context: context,
            isSuccess: true,
            title: 'Registrasi Event Berhasil',
            message: Text('Event anda telah terdaftar'),
            routeName: '/insertRace');
      }
    } catch (e) {
      showCustomDialog(
          context: context,
          isSuccess: false,
          title: 'Registrasi Event Gagal',
          message: Text(e.toString()),
          routeName: '/insertRace');
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

  void pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
        waktuController.text = time.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Responsivitas
    final width = screenWidth * (isSmallScreen ? 0.7 : 0.6);
    return Scaffold(
      backgroundColor: Colors.white,
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
                  'Create Event',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                MyTextField(
                  controller: namaEventController,
                  width: width,
                  hintText: 'Nama Event',
                  obScureText: false,
                ),

                SizedBox(height: 16),
                // MyTextField(
                //   controller: kategoriController,
                //   width: width,
                //   hintText: 'Kategori',
                //   obScureText: false,
                // ),

                MyDropdown(
                  hintText: "Kategori Event",
                  width: width,
                  items: [
                    'All Class',
                    'STO',
                    'Damper Style',
                    'STB',
                    'STB UP',
                    'Sloop',
                    'Nascar',
                  ], // Item dropdown
                  selectedValue: kategoriController, // Nilai terpilih
                  onChanged: (value) {
                    setState(() {
                      kategoriController = value; // Perbarui nilai terpilih
                    });
                  },
                ),

                SizedBox(height: 16),
                NumberTextField(
                  controller: htmController,
                  width: width,
                  hintText: 'HTM Event',
                  obScureText: false,
                ),
                SizedBox(height: 16),

                MyDateField(
                  controller: tanggalController,
                  width: width,
                  hintText: "Tanggal Event",
                  selectedDate: selectedDate,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedDate = date;

                      // Format tanggal ke ISO 8601 atau format lainnya
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(date);

                      // Isi controller dengan format tanggal
                      tanggalController.text = formattedDate;
                    });
                  },
                ),

                SizedBox(height: 16),
                // Time Picker
                GestureDetector(
                  onTap: pickTime,
                  child: AbsorbPointer(
                    child: MyTextField(
                      controller: waktuController,
                      width: width,
                      hintText: 'Waktu Event',
                      obScureText: false,
                      suffixIcon: Icons.access_time,
                      onSuffixIconTap: () {
                        print("Ikon jam ditekan!");
                        // Tambahkan logika, seperti membuka pemilih waktu
                      },
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Dropdown for Kota
                MyDropdown(
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
                  hintText: "Alamat Lengkap Event",
                  obScureText: false,
                  width: width,
                  maxLines: 3, // Menjadi Text Area dengan 5 baris
                  keyboardType: TextInputType
                      .multiline, // Mengatur keyboard agar mendukung multiline
                ),

                const SizedBox(height: 15),

                MyTextArea(
                  controller: deskripsiController,
                  hintText: "Deskripsi Event",
                  obScureText: false,
                  width: width,
                  maxLines: 3, // Menjadi Text Area dengan 5 baris
                  keyboardType: TextInputType
                      .multiline, // Mengatur keyboard agar mendukung multiline
                ),

                SizedBox(height: 24),

                // Sign in Button
                MyButton(
                  width: width,
                  label: "REGISTER",
                  ontap: () async {
                    // Panggil cekUsername terlebih dahulu
                    insertEvent(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

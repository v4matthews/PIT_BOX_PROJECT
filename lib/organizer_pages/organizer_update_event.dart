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
import 'package:pit_box/utils/cloudinary_service.dart';

class OrganizerUpdateEventPage extends StatefulWidget {
  final Map<String, dynamic> event;

  const OrganizerUpdateEventPage({Key? key, required this.event})
      : super(key: key);

  @override
  _OrganizerUpdateEventPageState createState() =>
      _OrganizerUpdateEventPageState();
}

class _OrganizerUpdateEventPageState extends State<OrganizerUpdateEventPage> {
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
    _loadInitialData();
    fetchRegionData();
  }

  void _loadInitialData() {
    // Isi data event ke dalam TextEditingController
    namaEventController.text = widget.event['nama_event'] ?? '';
    kategoriController = widget.event['kategori_event'] ?? '';
    htmController.text = widget.event['htm_event']?.toString() ?? '';
    tanggalController.text = widget.event['tanggal_event'] ?? '';
    waktuController.text = widget.event['waktu_event'] ?? '';
    selectedValue = widget.event['kota_event'] ?? '';
    alamatController.text = widget.event['alamat_event'] ?? '';
    deskripsiController.text = widget.event['deskripsi_event'] ?? '';
  }

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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateEvent(BuildContext context) async {
    try {
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

      String? imageUrl = widget.event['image_event'];
      if (selectedImage != null) {
        imageUrl = await CloudinaryService.uploadImage(selectedImage!);
        if (imageUrl == null) {
          throw Exception('Gagal mengunggah gambar ke Cloudinary');
        }
      }

      final result = await ApiService.updateEvent(
        idEvent: widget.event['_id'],
        namaEvent: namaEventController.text,
        kategoriEvent: kategoriController!,
        htmEvent: htmController.text,
        tanggalEvent: tanggalController.text,
        waktuEvent: waktuController.text,
        kotaEvent: selectedValue!,
        alamatEvent: alamatController.text,
        deskripsiEvent: deskripsiController.text,
        imageEvent: imageUrl,
      );

      if (result == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event berhasil diperbarui')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final width = screenWidth * 0.9;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
          'Edit Event',
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
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        : widget.event['image_event'] != null
                            ? Image.network(
                                widget.event['image_event'],
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
                const SizedBox(height: 20),
                MyTextField(
                  controller: namaEventController,
                  width: width,
                  hintText: 'Nama Event',
                  obScureText: false,
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                PriceTextField(
                  controller: htmController,
                  width: width,
                  hintText: 'HTM Event',
                  obScureText: false,
                ),
                const SizedBox(height: 20),
                MyDateField(
                  controller: tanggalController,
                  width: width,
                  hintText: "Tanggal Event",
                  selectedDate: selectedDate,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                      tanggalController.text =
                          DateFormat('yyyy-MM-dd').format(date);
                    });
                  },
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: selectedTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedTime = pickedTime;
                        waktuController.text = pickedTime.format(context);
                      });
                    }
                  },
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
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                MyTextArea(
                  controller: alamatController,
                  hintText: "Alamat Lengkap Event",
                  obScureText: false,
                  width: width,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 20),
                MyTextArea(
                  controller: deskripsiController,
                  hintText: "Deskripsi Event",
                  obScureText: false,
                  width: width,
                  maxLines: 7,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 24),
                MyLoadingButton(
                  label: "Update Event",
                  width: width,
                  onTap: () async {
                    await updateEvent(context);
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

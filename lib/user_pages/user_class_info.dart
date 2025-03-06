import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

class ClassInformationPage extends StatefulWidget {
  @override
  _ClassInformationPageState createState() => _ClassInformationPageState();
}

class _ClassInformationPageState extends State<ClassInformationPage> {
  String selectedClass = 'STB'; // Class yang dipilih secara default

  // Data untuk setiap class
  final Map<String, Map<String, String>> classData = {
    'STB': {
      'title': 'STB',
      'description': 'Kelas Pemula',
      'descpHeader':
          'STB (Standard Tamiya Box) adalah kelas pemula yang dirancang untuk pemain baru. Mobil dirakit langsung dari kit tanpa modifikasi tambahan.',
      'descpRule':
          'Aturan: Gunakan semua komponen standar dari kit. Tidak boleh menambahkan part atau aksesoris di luar bawaan. Motor yang digunakan: Mabuchi FA-130 atau S.M.C Motor.',
      'descpGoal':
          'Tujuan: Memperkenalkan dasar-dasar Mini 4WD. Memberikan pengalaman bermain yang mudah dan menyenangkan.',
      'image': '../assets/images/stb_info.jpg', // Path gambar untuk STB
    },
    'STB UP': {
      'title': 'STB UP',
      'description': 'Kelas Lanjutan STB',
      'descpHeader':
          'STB UP adalah kelas lanjutan dari STB yang memungkinkan modifikasi terbatas.',
      'descpRule':
          'Aturan: Diperbolehkan modifikasi terbatas sesuai dengan regulasi yang disepakati. Tetap menggunakan motor standar namun boleh dilakukan Break In.',
      'descpGoal':
          'Tujuan: Memberikan peluang kepada racer untuk dapat memodifikasi kit dengan beberapa peraturan yang telah disepakati.',
      'image': '../assets/images/stbup_info.jpg', // Path gambar untuk STB UP
    },
    'STO': {
      'title': 'STO',
      'description': 'Kelas Tune-Up Standar Tamiya Original',
      'descpHeader':
          'STO (Standard Tamiya Original) adalah kelas yang berdasar pada Japan Style. Dikhususkan untuk pemain yang sudah mahir dan ingin mengeksplorasi teknik tune-up.',
      'descpRule':
          'Aturan: Diperbolehkan modifikasi pada sasis, roda, dan komponen lainnya. Penggunaan Motor dibebaskan kepada peserta.',
      'descpGoal': 'Tujuan: Meningkatkan keterampilan tune-up pemain.',
      'image': '../assets/images/sto_info.jpg', // Path gambar untuk STO
    },
    'SIDE DAMPER TUNE': {
      'title': 'SIDE DAMPER TUNE',
      'description': 'Kelas Menengah Damper Tune Series',
      'descpHeader':
          'SIDE Damper Tune Series merupakan kelas yang memperbolehkan peserta untuk memodifikasi dengan menambahkan damper/pemberat untuk meningkatkan stabilitas mobil.',
      'descpRule':
          'Aturan: Menggunakan side damper. Diperbolehkan berkereasi dalam penggunaan set roda, penggunaan damper dan roller. Mesin dibatasi menggunakan Dinamo Tune Series',
      'descpGoal':
          'Tujuan: Meningkatkan keterampilan dalam menganalisa teknikalitas track.',
      'image':
          '../assets/images/tune_info.jpg', // Path gambar untuk SIDE DAMPER TUNE
    },
    'SIDE DAMPER DASH': {
      'title': 'SIDE DAMPER DASH',
      'description': 'Kelas Menengah Damper Dash Series',
      'descpHeader':
          'Kelas ini dirancang untuk balap cepat dengan menggunakan side damper.',
      'descpRule':
          'Aturan: Menggunakan side damper. Diperbolehkan berkereasi dalam penggunaan set roda, penggunaan damper dan roller. Diperbolehkan menggunakan Dinamo Dash Series',
      'descpGoal':
          'Tujuan: Meningkatkan keterampilan dalam balap cepat dan semi teknis.',
      'image':
          '../assets/images/dash_info.jpg', // Path gambar untuk SIDE DAMPER DASH
    },
    'NASCAR': {
      'title': 'NASCAR',
      'description': 'Kelas Balap dengan Gaya NASCAR',
      'descpHeader':
          'Kelas ini terinspirasi dari balap NASCAR, dengan fokus pada kecepatan dan stabilitas di lintasan oval.',
      'descpRule':
          'Aturan: Menggunakan setup khusus untuk lintasan oval. Diperbolehkan modifikasi untuk meningkatkan kecepatan dan stabilitas.',
      'descpGoal': 'Tujuan: Meningkatkan keterampilan dalam balap oval.',
      'image': '../assets/images/nascar_info.jpg', // Path gambar untuk NASCAR
    },
    'SLOOP': {
      'title': 'SLOOP',
      'description': 'Kelas Balap dengan Teknik Sloop',
      'descpHeader':
          'Kelas ini fokus pada teknik sloop, yaitu teknik melompati rintangan dengan presisi.',
      'descpRule':
          'Aturan: Menggunakan teknik sloop untuk melompati rintangan. Diperbolehkan modifikasi untuk meningkatkan presisi dan stabilitas.',
      'descpGoal': 'Tujuan: Meningkatkan keterampilan dalam teknik sloop.',
      'image': '../assets/images/sloop_info.jpg', // Path gambar untuk SLOOP
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          classData[selectedClass]!['title']!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Informasi class yang dipilih
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan gambar
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          classData[selectedClass]!['image']!,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          classData[selectedClass]!['description']!,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          classData[selectedClass]!['descpHeader']!,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          classData[selectedClass]!['descpRule']!,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          classData[selectedClass]!['descpGoal']!,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navbar untuk memilih class
          Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, -3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: classData.keys.map((String key) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedClass = key;
                      });
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedClass == key
                            ? AppColors
                                .primaryColor // Warna primary untuk item yang dipilih
                            : AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        key,
                        style: TextStyle(
                          color: selectedClass == key
                              ? Colors
                                  .white // Warna teks putih untuk item yang dipilih
                              : AppColors.blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

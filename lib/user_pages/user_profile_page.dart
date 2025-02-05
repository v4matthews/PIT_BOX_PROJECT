import 'package:flutter/material.dart';
import 'package:pit_box/api_service.dart';
import 'package:pit_box/components/asset_alert.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/asset_navbar.dart';
import 'package:pit_box/components/asset_textfield.dart';
import 'package:pit_box/components/asset_warna.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_update_profile_page.dart';
import 'package:pit_box/components/asset_alert.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController idUserController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController namaUserController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nomortlpnController = TextEditingController();
  final TextEditingController kotaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController statusUserController = TextEditingController();

  bool _isLoading = true;
  String? _profileImageUrl; // URL gambar profil

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userData = await SessionService.getUserData();
    setState(() {
      idUserController.text = userData['id_user'] ?? '';
      usernameController.text = userData['username'] ?? '';
      namaUserController.text = userData['nama_user'] ?? '';
      emailController.text = userData['email_user'] ?? '';
      nomortlpnController.text = userData['tlpn_user'] ?? '';
      kotaController.text = userData['kota_user'] ?? '';
      passwordController.text = userData['password_user'] ?? '';
      statusUserController.text = userData['status_user'] ?? 'Peserta';
      _profileImageUrl =
          userData['profile_image_url']; // Ambil URL gambar profil
      _isLoading = false;
    });
  }

  void _navigateToUpdatePage(String field, String value) async {
    if (field == 'email_user' || field == 'password_user') {
      // Tampilkan dialog untuk memverifikasi password
      final verified = await _verifyPassword(context);
      if (!verified) {
        return; // Jika password tidak valid, hentikan proses
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProfilePage(
          field: field,
          value: value,
          onUpdate: (newValue) {
            setState(() {
              if (field == 'nama_user') {
                namaUserController.text = newValue;
              } else if (field == 'email_user') {
                emailController.text = newValue;
              } else if (field == 'tlpn_user') {
                nomortlpnController.text = newValue;
              } else if (field == 'kota_user') {
                kotaController.text = newValue;
              } else if (field == 'password_user') {
                passwordController.text = newValue;
              }
            });
          },
        ),
      ),
    );
  }

  Future<bool> _verifyPassword(BuildContext context) async {
    final passwordController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Latar belakang putih
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Icon(
                Icons.lock, // Ikon untuk verifikasi password
                color: Color(0xFF4A59A9), // Warna ikon biru
                size: 64, // Ukuran ikon
              ),
              SizedBox(height: 10),
              Text(
                'Verifikasi Password',
                style: TextStyle(
                  color: Colors.black, // Teks judul berwarna hitam
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5), // Jarak antara judul dan konten
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Masukkan Password',
                  border: OutlineInputBorder(), // Border pada input field
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.grey, // Warna latar tombol abu-abu
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false); // Batal verifikasi
                    },
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.white, // Warna teks putih
                        fontWeight: FontWeight.bold, // Teks tebal
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF4A59A9), // Warna latar tombol biru
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    onPressed: () async {
                      final isValid = await ApiService.verifyPassword(
                          passwordController.text);
                      if (!isValid) {
                        // Tampilkan dialog error jika password tidak valid
                        showCustomDialog(
                          context: context,
                          isSuccess: false,
                          title: 'Error',
                          message: Text('Password tidak valid.'),
                          routeName: '/user_profile',
                        );
                        return;
                      }
                      Navigator.pop(context, true); // Verifikasi berhasil
                    },
                    child: Text(
                      'Verifikasi',
                      style: TextStyle(
                        color: Colors.white, // Warna teks putih
                        fontWeight: FontWeight.bold, // Teks tebal
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToUploadProfileImage() {
    // Navigasi ke halaman upload gambar profil
    // Anda bisa menambahkan logika untuk mengunggah gambar di sini
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UploadProfileImagePage(
          onImageUploaded: (imageUrl) {
            setState(() {
              _profileImageUrl = imageUrl;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Bagian Foto Profil dengan Latar Biru
                  Container(
                    color: AppColors.primaryColor, // Latar belakang biru
                    width: double.infinity, // Melebar penuh ke kiri
                    padding: EdgeInsets.only(top: 50, bottom: 30),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _navigateToUploadProfileImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                                Colors.transparent, // Hilangkan border
                            backgroundImage: _profileImageUrl != null
                                ? NetworkImage(_profileImageUrl!)
                                : null,
                            child: _profileImageUrl == null
                                ? Icon(
                                    Icons.account_circle,
                                    size: 100,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          onPressed: _navigateToUploadProfileImage,
                          child: Text(
                            'Ubah Foto Profil',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bagian Info Profile
                  SizedBox(height: 20),
                  _buildSectionHeader('Info Profile'),
                  _buildProfileInfoSection(),

                  // Bagian Info Detail
                  SizedBox(height: 20),
                  _buildSectionHeader('Info Detail'),
                  _buildProfileDetailSection(),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          _buildProfileRow('Username', usernameController.text, 'USERNAME',
              isEditable: false),
          _buildProfileRow('Nama', namaUserController.text, 'NAMA'),
          _buildProfileRow('Keterangan', statusUserController.text, 'STATUS'),
        ],
      ),
    );
  }

  Widget _buildProfileDetailSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          _buildProfileRow('Email', emailController.text, 'EMAIL'),
          _buildProfileRow('Nomor HP', nomortlpnController.text, 'TELEPON'),
          _buildProfileRow('Kota', kotaController.text, 'KOTA'),
          _buildProfileRowWithObscure(
              'Password', passwordController.text, 'PASSWORD'),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value, String field,
      {bool isEditable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap:
                  isEditable ? () => _navigateToUpdatePage(field, value) : null,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 18,
                        color: isEditable ? Colors.black : Colors.grey[600],
                      ),
                    ),
                  ),
                  if (isEditable) // Hanya tampilkan ikon jika baris bisa diedit
                    Icon(
                      Icons.chevron_right, // Ikon >
                      color: Colors.grey[600],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRowWithObscure(String label, String value, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => _navigateToUpdatePage(field, value),
              child: Text(
                '••••••••', // Menyembunyikan password
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadProfileImagePage extends StatelessWidget {
  final Function(String) onImageUploaded;

  UploadProfileImagePage({required this.onImageUploaded});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Foto Profil'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Logika untuk mengunggah gambar
            // Setelah berhasil, panggil onImageUploaded dengan URL gambar
            onImageUploaded('https://example.com/profile_image.jpg');
            Navigator.pop(context);
          },
          child: Text('Upload Gambar'),
        ),
      ),
    );
  }
}

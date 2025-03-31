import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

void showCustomLogoutDialog(BuildContext context, VoidCallback onLogout) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Sudut melengkung
        ),
        elevation: 10, // Shadow untuk dialog
        child: Container(
          padding: EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ukuran sesuai konten
            children: [
              // Ikon Logout
              Icon(
                Icons.logout,
                color: AppColors.primaryText, // Warna ikon merah
                size: 60,
              ),
              SizedBox(height: 16),

              // Judul
              Text(
                'Konfirmasi Logout',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                  color: AppColors.blackColor,
                ),
              ),
              SizedBox(height: 8),

              // Pesan
              Text(
                'Apakah Anda yakin ingin keluar?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: 40),

              // Tombol Batal dan Logout
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tombol Batal
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.grey, // Warna border abu-abu
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: 10), // Jarak antara tombol Batal dan Logout

                  // Tombol Logout
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Warna tombol merah
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context); // Tutup dialog
                      onLogout(); // Panggil fungsi logout
                    },
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'OpenSans',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

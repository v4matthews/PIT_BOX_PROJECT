import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

void showCancelReservationDialog(BuildContext context, VoidCallback onLogout) {
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
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ukuran sesuai konten
            children: [
              // Ikon Logout
              Icon(
                Icons.cancel_outlined,
                color: AppColors.primaryText, // Warna ikon merah
                size: 60,
              ),
              SizedBox(height: 16),

              // Judul
              Text(
                'Konfirmasi Cancel Reservasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'OpenSans',
                ),
              ),
              SizedBox(height: 8),

              // Pesan
              Text(
                'Apakah Anda yakin membatalkan reservasi?',
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
                        fontSize: 16,
                        fontFamily: 'OpenSans',
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
                      'Konfirmasi',
                      style: TextStyle(
                          color: Colors.white,
                          // fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'OpenSans'),
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

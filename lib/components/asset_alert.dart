import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

void showCustomDialog({
  required BuildContext context,
  required bool isSuccess, // Menentukan apakah sukses atau gagal
  required String title, // Judul dialog
  required Widget message, // Pesan dialog (bisa berupa Widget seperti Text)
  required String routeName, // Nama route yang akan dipanggil
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Latar belakang putih
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Icon(
              isSuccess
                  ? Icons.check_circle
                  : Icons.error, // Ikon tergantung status
              color: isSuccess
                  ? Colors.green
                  : Colors.red, // Warna ikon sukses atau gagal
              size: 64, // Ukuran ikon
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.black, // Teks judul berwarna hitam
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5), // Jarak antara judul dan konten
            message, // Menampilkan pesan (sekarang bisa Widget)
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    AppColors.accentColor, // Warna latar tombol biru
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Navigator.pushReplacementNamed(context, routeName);
                }
                // Gunakan routeName
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.white, // Warna teks putih
                  fontWeight: FontWeight.bold, // Teks tebal
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

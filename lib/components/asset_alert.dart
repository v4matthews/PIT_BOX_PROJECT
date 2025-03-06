import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

void showCustomDialog({
  required BuildContext context,
  required bool isSuccess, // Menentukan apakah sukses atau gagal
  required String title, // Judul dialog
  required Widget message, // Pesan dialog
  required String routeName, // Route yang akan dipanggil
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showGeneralDialog(
    context: context,
    barrierDismissible: true, // Bisa ditutup dengan klik di luar
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: Duration(milliseconds: 200), // Durasi animasi
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
          child: ScaleTransition(
        scale: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack, // Efek "bounce" saat muncul
        ),
        child: Dialog(
          elevation: 10, // Shadow untuk dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.9, // Lebar maksimum 80% dari layar
                maxHeight: screenHeight * 0.7, // Tinggi maksimum 50% dari layar
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSuccess
                          ? Icons.check_circle
                          : Icons.error, // Ikon sukses/gagal
                      color: isSuccess ? Colors.green : Colors.red,
                      size: 72,
                    ),
                    SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat', // Gunakan font yang menarik
                      ),
                    ),
                    SizedBox(height: 16),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Center(
                          child: message is Text
                              ? Text(
                                  (message as Text).data ?? '',
                                  textAlign: TextAlign.center,
                                  style: (message as Text).style?.copyWith(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                      ),
                                )
                              : message,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors
                                .primaryText, // Warna border sesuai status
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (isSuccess) {
                            Navigator.pushReplacementNamed(context, routeName);
                          }
                        },
                        child: Text(
                          'OKE',
                          style: TextStyle(
                            color: AppColors.primaryText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ));
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
    },
  );
}

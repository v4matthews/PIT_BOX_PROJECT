import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

void showResendVerificationDialog({
  required BuildContext context,
  required String username,
  required Function resendAction, // Function to resend the email
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  showGeneralDialog(
    context: context,
    barrierDismissible: true, // Allows closing by tapping outside
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    transitionDuration: Duration(milliseconds: 200), // Animation duration
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutBack, // "Bounce" effect when showing
          ),
          child: Dialog(
            elevation: 10, // Shadow for the dialog
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20), // Border radius of the dialog
            ),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor, // Background color of the dialog
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.9, // Max width of 80% of the screen
                maxHeight:
                    screenHeight * 0.7, // Max height of 50% of the screen
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.email_outlined,
                      color: Colors.grey[700], // Icon color
                      size: 72,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Email Belum Diverifikasi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat', // Use a more attractive font
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Akun Anda belum diverifikasi. Ingin mengirim ulang email verifikasi?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryText, // Border color
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: Text(
                            'Batal',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.primaryText, // Border color
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close dialog
                            await resendAction(
                                username); // Call the resend action
                          },
                          child: Text(
                            'Kirim Ulang',
                            style: TextStyle(
                              color: AppColors.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
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

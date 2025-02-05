import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

class MyTextArea extends StatelessWidget {
  final TextEditingController controller; // Tipe spesifik
  final String hintText;
  final bool obScureText;
  final double width;
  final int maxLines; // Tambahkan parameter untuk jumlah baris
  final TextInputType keyboardType; // Menentukan jenis keyboard

  const MyTextArea({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obScureText,
    this.width = 500, // Default width
    this.maxLines = 1, // Default baris hanya 1
    this.keyboardType = TextInputType.text, // Default keyboard adalah teks
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Konsisten dengan UI modern
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width, // Lebar maksimum
        ),
        child: TextField(
          controller: controller,
          obscureText: obScureText,
          maxLines: maxLines, // Menentukan jumlah baris (untuk Text Area)
          keyboardType: keyboardType, // Jenis keyboard
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(16),
            ),
            fillColor: AppColors.whiteColor,
            filled: true,
            label: Text(hintText),
            labelStyle: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }
}

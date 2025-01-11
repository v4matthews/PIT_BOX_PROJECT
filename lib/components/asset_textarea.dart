import 'package:flutter/material.dart';

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
              borderSide: BorderSide.none, // Hilangkan garis saat tidak fokus
              borderRadius: BorderRadius.circular(12), // Sudut melengkung
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey.shade600), // Garis saat fokus
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey.shade200, // Warna latar belakang
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500], // Warna hint teks
            ),
          ),
        ),
      ),
    );
  }
}

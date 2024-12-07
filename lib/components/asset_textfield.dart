import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller; // Tipe spesifik
  final String hintText;
  final bool obScureText;
  final double width;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obScureText,
    this.width = 500, // Default width
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Konsisten dengan UI modern
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width, // Lebar maksimum
          maxHeight: 50, // Tinggi maksimum
        ),
        child: TextField(
          controller: controller,
          obscureText: obScureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none, // Hilangkan garis saat tidak fokus
              borderRadius: BorderRadius.circular(12), // Sudut melengkung
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey.shade400), // Garis saat fokus
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

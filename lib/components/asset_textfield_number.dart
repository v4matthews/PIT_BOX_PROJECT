import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberTextField extends StatelessWidget {
  final TextEditingController controller; // Tipe spesifik
  final String hintText;
  final bool obScureText;
  final double width;

  const NumberTextField({
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Hanya angka yang diterima
          ],
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.white,
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

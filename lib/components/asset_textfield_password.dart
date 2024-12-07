import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    this.width = 500, // Default width jika tidak diberikan
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true; // Menyembunyikan teks secara default

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Konsisten dengan UI modern
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.width, // Lebar maksimum
          maxHeight: 50, // Tinggi maksimum
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: _obscureText, // Menyembunyikan atau menampilkan password
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none, // Hilangkan garis saat tidak fokus
              borderRadius: BorderRadius.circular(12), // Sudut melengkung
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade400, // Garis saat fokus
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey.shade200, // Warna latar belakang
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500], // Warna hint teks
            ),
            suffixIcon: Padding(
              padding:
                  const EdgeInsets.only(right: 8.0), // Menggeser ikon ke kiri
              child: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off
                      : Icons.visibility, // Ikon toggle
                  color: Colors.grey[500], // Warna ikon
                  size: 20, // Menyesuaikan ukuran ikon
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText; // Toggle nilai _obscureText
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

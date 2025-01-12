import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obScureText;
  final double width;
  final IconData? suffixIcon; // Ikon di bagian kanan, opsional
  final VoidCallback? onSuffixIconTap; // Fungsi ketika ikon ditekan

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obScureText,
    this.width = 500,
    this.suffixIcon,
    this.onSuffixIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width,
          maxHeight: 50,
        ),
        child: TextField(
          controller: controller,
          obscureText: obScureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
            ),
            suffixIcon: suffixIcon != null
                ? GestureDetector(
                    onTap: onSuffixIconTap, // Tindakan ketika ikon ditekan
                    child: Icon(
                      suffixIcon,
                      color: Colors.grey[600],
                    ),
                  )
                : null, // Tampilkan ikon jika tersedia
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;
  final Function(String)? onChanged;
  final bool showValidation; // Tambahkan flag untuk menampilkan validasi

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
    this.width = 500,
    this.onChanged,
    this.showValidation = false, // Secara default, validasi tidak muncul
  });

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;
  String? _errorText;

  // Fungsi validasi password
  void _validatePassword(String value) {
    if (!widget.showValidation) return; // Hanya validasi jika diizinkan

    setState(() {
      if (value.isEmpty) {
        _errorText = 'Password tidak boleh kosong';
      } else if (value.length < 8) {
        _errorText = 'Password harus memiliki minimal 8 karakter';
      } else if (!RegExp(r'[0-9]').hasMatch(value)) {
        _errorText = 'Password harus mengandung setidaknya satu angka';
      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
        _errorText = 'Password harus mengandung setidaknya satu huruf kapital';
      } else {
        _errorText = null; // Jika valid, hapus error
      }
    });

    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.width,
              maxHeight: 50,
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              onChanged: _validatePassword, // Validasi hanya saat teks berubah
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorText != null
                        ? Colors.red // Border merah jika ada error
                        : Colors.grey.shade600,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorText != null
                        ? Colors.red // Border merah jika ada error
                        : Colors.grey.shade600,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.white,
                filled: true,
                labelText: widget.hintText,
                labelStyle: TextStyle(
                  color: Colors.grey[500],
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey[500],
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          if (_errorText != null &&
              widget.showValidation) // Validasi hanya saat diperlukan
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

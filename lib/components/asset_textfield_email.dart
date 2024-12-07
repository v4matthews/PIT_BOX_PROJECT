import 'package:flutter/material.dart';

class EmailTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obScureText;
  final double width;

  const EmailTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obScureText,
    this.width = 500,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<EmailTextField> {
  String? _errorMessage; // Pesan error untuk ditampilkan

  // Validasi email menggunakan RegEx sederhana
  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorMessage = 'Email tidak boleh kosong';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _errorMessage = 'Masukkan format email yang valid';
      } else {
        _errorMessage = null; // Input valid, error dihapus
      }
    });
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
              maxWidth: widget.width, // Lebar sesuai parameter
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.obScureText,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorMessage != null
                        ? Colors.red
                        : Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                ),
                errorText: _errorMessage, // Tampilkan error di dalam TextField
              ),
              onChanged: _validateEmail, // Validasi setiap kali teks berubah
            ),
          ),
        ],
      ),
    );
  }
}

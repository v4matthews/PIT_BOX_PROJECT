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
  _EmailTextFieldState createState() => _EmailTextFieldState();
}

class _EmailTextFieldState extends State<EmailTextField> {
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
              maxWidth: widget.width,
              maxHeight: 50,
            ),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.obScureText,
              onChanged: _validateEmail, // Validasi setiap kali teks berubah
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _errorMessage != null
                        ? Colors.red
                        : Colors.grey.shade400,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(16),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(16),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

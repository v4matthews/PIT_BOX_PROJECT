import 'package:flutter/material.dart';

class MyIconShortcut extends StatelessWidget {
  final String initial; // Inisial huruf
  final String label; // Label di bawah lingkaran
  final double initialSize;
  final Color backgroundColor; // Warna lingkaran

  const MyIconShortcut({
    Key? key,
    required this.initial,
    required this.label,
    this.initialSize = 14,
    this.backgroundColor = const Color(0xFF4A59A9), // Warna default lingkaran
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lingkaran dengan inisial huruf
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initial,
              style: TextStyle(
                color: Colors.white,
                fontSize: initialSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Label di bawah lingkaran
        Text(
          label,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

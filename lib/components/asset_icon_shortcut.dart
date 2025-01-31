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
    this.backgroundColor = const Color(0xFF4A59A9),
    // this.backgroundColor = const Color(0xFFD3D3D3),
    // this.backgroundColor = const Color(0xFFA9A9A9),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Menyesuaikan untuk layar kecil
    final width = screenWidth * (isSmallScreen ? 0.12 : 0.09);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lingkaran dengan inisial huruf
        Container(
          width: width,
          height: width,
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
          style: TextStyle(
              color: Colors.grey[700], fontSize: isSmallScreen ? 14 : 18),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

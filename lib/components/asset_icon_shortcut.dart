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
    this.backgroundColor = const Color(0xFFD9D9D9),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double iconSize =
        isSmallScreen ? screenHeight * 0.06 : screenHeight * 0.08;

    // Menyesuaikan ukuran berdasarkan kategori layar

    final fontSize = isSmallScreen ? 12.0 : 16.0;
    final labelFontSize = isSmallScreen ? 14.0 : 18.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Lingkaran dengan inisial huruf
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              initial,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
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
            color: Colors.grey[700],
            fontSize: labelFontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

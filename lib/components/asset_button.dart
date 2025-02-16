import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

class MyButton extends StatelessWidget {
  final VoidCallback? ontap; // Tipe yang lebih eksplisit
  final String label;
  final Color color;
  final double width;

  const MyButton({
    super.key,
    required this.ontap,
    required this.label,
    this.color = AppColors.primaryColor, // Warna default
    this.width = 150.0, // Lebar default
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width, // Lebar tombol
        height: 50, // Tinggi tombol tetap
        margin:
            const EdgeInsets.symmetric(horizontal: 4), // Margin antar elemen
        decoration: BoxDecoration(
          color: color, // Warna tombol
          borderRadius: BorderRadius.circular(8), // Sudut melengkung
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white, // Warna teks putih secara default
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String hintText;
  final List<String> items; // Daftar item dropdown
  final String? selectedValue; // Nilai terpilih
  final ValueChanged<String?> onChanged; // Callback ketika nilai berubah
  final double width;
  final IconData? suffixIcon;

  const MyDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.width = 500,
    this.suffixIcon = Icons.arrow_drop_down, // Default ikon dropdown
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
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Warna latar belakang
            borderRadius: BorderRadius.circular(12),

            // border: Border.all(
            //   color: Colors.grey.shade300, // Warna border
            //   width: 0,
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                hint: Text(
                  hintText,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                icon: Icon(
                  suffixIcon,
                  color: Colors.grey[600],
                ),
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                isExpanded: true, // Dropdown mengisi lebar penuh
              ),
            ),
          ),
        ),
      ),
    );
  }
}

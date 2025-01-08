import 'package:flutter/material.dart';

class MyDropdown extends StatelessWidget {
  final String hintText;
  final double width;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const MyDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.width = 500, // Default width
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Konsisten dengan UI modern
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width, // Lebar maksimum
          maxHeight: 50, // Tinggi maksimum
        ),
        child: DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none, // Hilangkan garis saat tidak fokus
              borderRadius: BorderRadius.circular(12), // Sudut melengkung
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey.shade400), // Garis saat fokus
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey.shade200, // Warna latar belakang
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0, // Padding vertikal
              horizontal: 16.0, // Padding horizontal
            ),
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 16, // Warna hint teks
            ),
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}

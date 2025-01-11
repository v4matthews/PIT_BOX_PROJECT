import 'package:flutter/material.dart';

class MyDateField extends StatelessWidget {
  final TextEditingController controller; // Tipe spesifik
  final String hintText;
  final DateTime? selectedDate;
  final double width;
  final Function(DateTime) onDateSelected;

  const MyDateField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onDateSelected,
    this.selectedDate,
    this.width = 500, // Default width
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 16.0), // Konsisten dengan UI modern
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width, // Lebar maksimum berdasarkan parameter width
          maxHeight: 50, // Tinggi maksimum
        ),
        child: TextFormField(
          controller: controller,
          readOnly: true, // Hanya bisa diubah lewat dialog
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none, // Hilangkan garis saat tidak fokus
              borderRadius: BorderRadius.circular(12), // Sudut melengkung
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.grey.shade600), // Garis saat fokus
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.grey.shade200, // Warna latar belakang
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey[500], // Warna hint teks
            ),
            suffixIcon: Icon(Icons.calendar_today), // Ikon kalender
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(
                  pickedDate); // Memanggil fungsi untuk memperbarui selectedDate
              controller.text = pickedDate.toLocal().toString().split(' ')[0];
            }
          },
        ),
      ),
    );
  }
}

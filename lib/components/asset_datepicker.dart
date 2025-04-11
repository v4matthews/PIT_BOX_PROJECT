import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan ini untuk format tanggal

class MyDateField extends StatelessWidget {
  final TextEditingController controller;
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
    this.width = 500,
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
        child: TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600),
              borderRadius: BorderRadius.circular(12),
            ),
            fillColor: Colors.white,
            filled: true,
            label: Text(hintText),
            labelStyle: TextStyle(
              color: Colors.grey[500],
            ),
            suffixIcon: Icon(
              Icons.calendar_today,
              color: Colors.grey[600],
            ),
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              builder: (BuildContext context, Widget? child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    dialogBackgroundColor:
                        Colors.black, // Mengatur background menjadi putih
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
              // Format tanggal menjadi dd MMM yyyy
              controller.text = DateFormat('dd MMM yyyy').format(pickedDate);
            }
          },
        ),
      ),
    );
  }
}

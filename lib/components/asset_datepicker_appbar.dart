import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_warna.dart';

class MyAppbarDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final DateTime? selectedDate;
  final double width;
  final Function(DateTime) onDateSelected;

  const MyAppbarDatePicker({
    super.key,
    required this.controller,
    required this.onDateSelected,
    this.selectedDate,
    this.width = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
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
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(16),
            ),
            fillColor: AppColors.secondaryColor,
            filled: true,
            hintText: 'Pilih tanggal perlombaan',
            hintStyle: TextStyle(
              fontFamily: 'Montserrat',
              color: AppColors.secondaryLightColor,
            ),
            suffixIcon: Icon(
              Icons.calendar_today_outlined,
              color: AppColors.secondaryLightColor,
            ),
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
              controller.text = pickedDate.toLocal().toString().split(' ')[0];
            }
          },
        ),
      ),
    );
  }
}

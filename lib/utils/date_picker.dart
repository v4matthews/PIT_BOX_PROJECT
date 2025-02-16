import 'package:flutter/material.dart';

class DatePickerPage extends StatefulWidget {
  @override
  _DatePickerPageState createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pilih Tanggal")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              selectedDate == null
                  ? "Belum ada tanggal yang dipilih"
                  : "Tanggal yang dipilih: ${selectedDate!.toLocal()}"
                      .split(' ')[0],
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("Pilih Tanggal"),
            ),
          ],
        ),
      ),
    );
  }
}

// Cara memanggil halaman ini dari halaman lain:
// final selectedDate = await Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => DatePickerPage()),
// );
// print("Tanggal yang dipilih: \$selectedDate");

import 'package:flutter/material.dart';
import 'package:pit_box/components/asset_butto_squircle.dart';
import 'package:pit_box/components/asset_button.dart';
import 'package:pit_box/components/component_textfield_kotak.dart';

class UpdateProfilePage extends StatefulWidget {
  final String field;
  final String value;
  final Function(String) onUpdate;

  UpdateProfilePage({
    required this.field,
    required this.value,
    required this.onUpdate,
  });

  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.value;
  }

  void _updateValue() {
    widget.onUpdate(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth * 0.8;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A59A9),
        title: Text(
          'UPDATE ${widget.field}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0), // Atur padding sesuai kebutuhan
                child: Text(
                  'Harap memasukkan data yang valid agar proses pendaftaran event dapat berjalan dengan baik.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 20),
              PitBoxTextField2(
                controller: _controller,
                hintText: widget.field,
                obScureText: false,
                width: width,
              ),
              SizedBox(height: 20),
              PitBoxSquircleButton(
                ontap: _updateValue,
                label: "UPDATE",
                width: width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

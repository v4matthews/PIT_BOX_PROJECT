import 'package:flutter/material.dart';

class MyButtonRegister extends StatelessWidget {
  final Function()? ontap;

  const MyButtonRegister({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 50,
        // width: 350,
        // padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Color(0xFFFFC700), //Nanti ganti ke kuning
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

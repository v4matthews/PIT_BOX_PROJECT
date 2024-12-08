// import 'package:flutter/material.dart';
// import 'package:pit_box/dbConfig/mongodb.dart';
// import 'pages/login_page.dart';
// import 'pages/register_page.dart';
// import 'pages/home_page.dart';
// import 'pages/detail_lomba.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await MongoDatabase.connect();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         initialRoute: '/',
//         routes: {
//           '/login': (context) => LoginPage(), // Halaman utama
//           '/register': (context) => RegisterPage(),
//           '/home': (context) => HomePage(), // Rute untuk LoginPage
//           '/detailLomba': (context) => DetailLomba(), // Rute untuk LoginPage
//         },
//         home: LoginPage());
//     // home: LoginPage());
//     // home: DetailLomba());
//   }
// }

// User Pages
import 'package:flutter/material.dart';
import 'package:pit_box/user_pages/user_register_page.dart';
import 'package:pit_box/user_pages/user_login_page.dart';
import 'package:pit_box/user_pages/user_forgot.dart';

// Organizer Pages
import 'package:pit_box/organizer_pages/organizer_login_page.dart';
import 'package:pit_box/organizer_pages/organizer_forgot.dart';
import 'package:pit_box/organizer_pages/organizer_register_page.dart';

import 'user_pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pit Box',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // initialRoute: '/register',
      // initialRoute: '/loginOrganizer',
      initialRoute: '/login',

      // Organizer Route
      routes: {
        // User Route
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/forgotUser': (context) => UserForgetPassword(),

        // Organizer Route
        '/loginOrganizer': (context) => OrganizerLoginPage(),
        '/forgotOrganizer': (context) => OrganizerForgotPassword(),
        '/registerOrganizer': (context) => OrganizerRegisterPage(),
      },
    );
  }
}

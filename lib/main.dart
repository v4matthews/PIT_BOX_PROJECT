// User Pages
import 'package:flutter/material.dart';
import 'package:pit_box/organizer_pages/organizer_home.dart';
import 'package:pit_box/race_page/detail_page.dart';
import 'package:pit_box/user_pages/user_register_page.dart';
import 'package:pit_box/user_pages/user_login_page.dart';
import 'package:pit_box/user_pages/user_forgot.dart';
import 'package:pit_box/user_pages/user_home.dart';

// Organizer Pages
import 'package:pit_box/organizer_pages/organizer_login_page.dart';
import 'package:pit_box/organizer_pages/organizer_forgot.dart';
import 'package:pit_box/organizer_pages/organizer_register_page.dart';
import 'package:pit_box/organizer_pages/organizer_register_event.dart';
import 'package:pit_box/organizer_pages/organizer_insert_race.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        widget,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.resize(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(color: Colors.grey[300]),
      ),
      // title: 'Pit Box',
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),

      // initialRoute: '/register',
      // initialRoute: '/loginOrganizer',
      // initialRoute: '/home',
      // initialRoute: '/insertRace',
      initialRoute: '/home',

      // Organizer Route
      routes: {
        // User Route
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => UserHome(),
        '/forgotUser': (context) => UserForgetPassword(),

        // Organizer Route
        '/loginOrganizer': (context) => OrganizerLoginPage(),
        '/forgotOrganizer': (context) => OrganizerForgotPassword(),
        '/registerOrganizer': (context) => OrganizerRegisterPage(),
        '/homeOrganizer': (context) => organizerHome(),
        // '/insertRace': (context) => EventFormPage(),
        '/insertRace': (context) => OrganizerRegisterEvent(),
      },
    );
  }
}

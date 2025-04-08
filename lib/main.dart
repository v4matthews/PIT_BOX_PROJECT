import 'package:flutter/material.dart';
import 'package:pit_box/organizer_pages/organizer_home_page.dart';
import 'package:pit_box/organizer_pages/organizer_dashboard.dart';
import 'package:pit_box/race_page/detail_page.dart';
import 'package:pit_box/session_service.dart';
import 'package:pit_box/user_pages/user_class_info.dart';
import 'package:pit_box/user_pages/user_dashboard.dart';
import 'package:pit_box/user_pages/user_profile_page.dart';
import 'package:pit_box/user_pages/user_register_page.dart';
import 'package:pit_box/user_pages/user_login_page.dart';
import 'package:pit_box/user_pages/user_forgot.dart';
import 'package:pit_box/user_pages/user_update_profile.dart';
// import 'package:pit_box/user_pages/user_home_page_old.dart';

// Organizer Pages
import 'package:pit_box/organizer_pages/organizer_login_page.dart';
import 'package:pit_box/organizer_pages/organizer_forgot.dart';
import 'package:pit_box/organizer_pages/organizer_register_page.dart';
import 'package:pit_box/organizer_pages/organizer_register_event.dart';
// import 'package:pit_box/organizer_pages/organizer_insert_race.dart';
import 'package:pit_box/user_pages/user_ticket.dart';
import 'package:pit_box/utils/payment_failed.dart';
import 'package:pit_box/utils/payment_success.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:pit_box/race_page/test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isLoggedIn = await SessionService.isLoggedIn();
  String? userType = await SessionService.getUserType();

  String initialRoute;

  if (!isLoggedIn) {
    initialRoute = '/login';
  } else {
    initialRoute = userType == 'organizer' ? '/homeOrganizer' : '/home';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required this.initialRoute});

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
      initialRoute: initialRoute,
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => UserDashboard(),
        '/forgotUser': (context) => UserForgetPassword(),
        '/loginOrganizer': (context) => OrganizerLoginPage(),
        '/forgotOrganizer': (context) => OrganizerForgotPassword(),
        '/registerOrganizer': (context) => OrganizerRegisterPage(),
        '/homeOrganizer': (context) => OrganizerHomePage(),
        '/insertRace': (context) => OrganizerRegisterEvent(),
        '/profile': (context) => UserProfilePage(),
        '/ticket': (context) => TicketListPage(),
        '/classInfo': (context) => ClassInformationPage(),
        '/updateProfile': (context) => UserUpdateProfile(),
        '/paymentSuccess': (context) => PaymentSuccessPage(),
        '/paymentFailed': (context) => PaymentFailedPage(),
      },
    );
  }
}

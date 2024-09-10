import 'package:flutter/material.dart';
import 'package:my_flutter_app/screens/dashboard_screen.dart';
import 'package:my_flutter_app/screens/strenge_web_screen.dart';
import 'package:my_flutter_app/screens/map_screen.dart';
import 'package:my_flutter_app/screens/crm_web_screen.dart';
import 'package:my_flutter_app/styles/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sales Representative App',
      theme: appTheme,
      home: const DashboardScreen(),
      routes: {
        '/strengeweb': (context) {
          print('Navigating to Strenge Web Screen');
          return const StrengeWebScreen();
        },
        '/map': (context) {
          print('Navigating to Map Screen');
          return const MapScreen();
        },
        '/crm': (context) {
          print('Navigating to CRM Screen');
          return const CRMWebScreen();
        },
      },
    );
  }
}

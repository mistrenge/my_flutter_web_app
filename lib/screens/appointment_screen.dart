import 'package:flutter/material.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terminplanung'),
      ),
      body: const Center(
        child: Text('Hier wird die Terminplanung angezeigt'),
      ),
    );
  }
}

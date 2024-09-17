import 'package:flutter/material.dart';
import 'package:my_flutter_app/styles/styles.dart'; // Importiere deine primaryColor

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor, // Setzt den Hintergrund auf primaryColor
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Logo oben
            const SizedBox(height: 40), // Abstand nach oben
            Center(
              child: Image.asset(
                'assets/Strenge Logo.png', // Pfad zu deinem Logo-Bild
                height: 40, // Größe des Logos anpassen
              ),
            ),
            const SizedBox(height: 40), // Abstand zwischen Logo und Box

            // Weiße Box mit abgerundeten Ecken, limitierter Höhe und Breite
            Center(
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Maximale Breite der Box
                  maxHeight: 500, // Maximale Höhe der Box
                ),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16), // Leicht abgerundete Ecken
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Box nimmt nur den benötigten Platz ein
                  children: <Widget>[
                    // Überschrift
                    const Text(
                      'Pocket CRM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24), // Abstand zwischen Text und Buttons

                    // Kartenansicht Button
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.map, size: 32, color: fourthColor),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Kartenansicht',
                            style: TextStyle(fontSize: 20, color: fourthColor),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Hintergrundfarbe der Buttons
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Leicht abgerundete Buttons
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shadowColor: Colors.black, // Schattenfarbe (Schwarz)
                          elevation: 10, // Erhöht die Höhe des Schattens
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/map');
                        },
                      ),
                    ),
                    const SizedBox(height: 16), // Abstand zwischen den Buttons

                    // Strenge Website Button
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.web, size: 32, color: fourthColor),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Strenge Website',
                            style: TextStyle(fontSize: 20, color: fourthColor),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shadowColor: Colors.black, // Schattenfarbe (Schwarz)
                          elevation: 10, // Erhöht die Höhe des Schattens
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/strengeweb');
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // CRM Button
                    SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.business, size: 32, color: fourthColor),
                        label: const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CRM Ebootis',
                            style: TextStyle(fontSize: 20, color: fourthColor),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shadowColor: Colors.black, // Schattenfarbe (Schwarz)
                          elevation: 10, // Erhöht die Höhe des Schattens
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/crm');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_flutter_app/styles/styles.dart'; // Importiere die Styles


// Bedingte Importe
import 'package:my_flutter_app/services/platform_helper_stub.dart'
    if (dart.library.io) 'package:my_flutter_app/services/platform_helper_mobile.dart'
    if (dart.library.html) 'package:my_flutter_app/services/platform_helper_web.dart';


void showMarkedCompaniesDialog(BuildContext context, List<Map<String, dynamic>> markedCompanies, void Function(Map<String, dynamic>) onToggleFavorite, LatLng currentPosition) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MarkedCompaniesDialog(
        companies: List.from(markedCompanies),
        onToggleFavorite: onToggleFavorite,
        currentPosition: currentPosition,
      );
    },
  );
}

class MarkedCompaniesDialog extends StatefulWidget {
  final List<Map<String, dynamic>> companies;
  final void Function(Map<String, dynamic>) onToggleFavorite;
  final LatLng currentPosition;

  const MarkedCompaniesDialog({
    super.key,
    required this.companies,
    required this.onToggleFavorite,
    required this.currentPosition,
  });

  @override
  _MarkedCompaniesDialogState createState() => _MarkedCompaniesDialogState();
}

class _MarkedCompaniesDialogState extends State<MarkedCompaniesDialog> {
  late List<Map<String, dynamic>> _companies;

  @override
  void initState() {
    super.initState();
    _companies = List.from(widget.companies); // Kopie der Liste für lokale Änderungen
  }

  void _sortCompaniesByDistance() {
  setState(() {
    _companies.sort((a, b) {
      // Berechnen der Entfernung für beide Unternehmen
      double distanceA = _calculateDistance(
        widget.currentPosition,
        LatLng(a['latitude'], a['longitude']),
      );
      double distanceB = _calculateDistance(
        widget.currentPosition,
        LatLng(b['latitude'], b['longitude']),
      );

      // Rückgabe des Vergleichswerts für die Sortierung
      return distanceA.compareTo(distanceB);
    });

    // Überprüfen der sortierten Liste
    for (var company in _companies) {
      double distance = _calculateDistance(
        widget.currentPosition,
        LatLng(company['latitude'], company['longitude']),
      );
    
    }
  });
}


  double _calculateDistance(LatLng start, LatLng end) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  void _openInGoogleMaps() async {
    if (_companies.isNotEmpty) {
      // Konvertiere die Koordinaten in Strings, falls notwendig
      String origin = '${widget.currentPosition.latitude.toString()},${widget.currentPosition.longitude.toString()}';
      String destination = '${_companies.last['latitude'].toString()},${_companies.last['longitude'].toString()}';
      
      String waypoints = _companies
          .sublist(0, _companies.length - 1)
          .map((company) => '${company['latitude'].toString()},${company['longitude'].toString()}')
          .join('|');

      // Debug-Ausgabe
      print('Origin: $origin (Type: ${origin.runtimeType})');
      print('Destination: $destination (Type: ${destination.runtimeType})');
      print('Waypoints: $waypoints (Type: ${waypoints.runtimeType})');

      try {
        print('Versuche, die Plattform zu erkennen...');
        
        String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&waypoints=$waypoints';

        if (isMobilePlatform()) {
          // Öffne die Google Maps App auf Android oder iOS
          print('IOS bzw Android erkannt');
          final googleMapsAppUrl = 'google.navigation:q=$destination&waypoints=$waypoints';

          if (await canLaunch(googleMapsAppUrl)) {
            await launch(googleMapsAppUrl);
          } else if (await canLaunch(googleMapsUrl)) {
            await launch(googleMapsUrl);
          } else {
            throw 'Could not launch Google Maps';
          }
        } else {
          // Öffne die Google Maps Webseite auf anderen Plattformen (z.B. Web)
          print('Web erkannt');
          if (await canLaunch(googleMapsUrl)) {
            await launch(googleMapsUrl);
          } else {
            throw 'Could not launch $googleMapsUrl';
          }
        }
      } catch (e) {
        // Fehler abfangen und debuggen
        print('Ein Fehler ist aufgetreten: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ausgewählte Zielkunden'),
      content: SizedBox(
        width: double.maxFinite, // Breite maximieren
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Begrenze die Höhe des ListView
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 300, // Maximale Höhe für die Liste festlegen
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _companies.length,
                itemBuilder: (context, index) {
                  final company = _companies[index];
                  // Berechne die Entfernung zum aktuellen Standort
                  final companyLocation = LatLng(
                    company['latitude'],
                    company['longitude'],
                  );
                  final distance = _calculateDistance(widget.currentPosition, companyLocation);

                  return ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: primaryColor,
                    ),
                    title: Text(company['Firma']),
                    subtitle: Text(
                      '${company['Adresse']}\nEntfernung: ${distance.toStringAsFixed(2)} km',
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: primaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _companies.remove(company);
                        });
                        widget.onToggleFavorite(company);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Column(
             
              children: [
                ElevatedButton(
                  onPressed: _sortCompaniesByDistance,
                  child: const Text('Nach Entfernung sortieren'),
                ),
                const SizedBox(height: 8), // Abstand zwischen den Buttons
                ElevatedButton(
                  onPressed: _openInGoogleMaps,
                  child: const Text('Route in Google Maps'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Schließen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

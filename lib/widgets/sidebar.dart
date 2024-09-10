import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart'; // Für Entfernung
import 'package:my_flutter_app/services/filter_service.dart'; // Importiere den DataService
import 'package:my_flutter_app/styles/styles.dart'; // Importiere die Styles
import 'package:my_flutter_app/models/custom_multiselect_dropdown.dart'; // Importiere die benutzerdefinierte MultiSelectDropdown-Komponente

class Sidebar extends StatefulWidget {
  final bool isOpen;
  final VoidCallback onToggle;
  final List<Map<String, dynamic>> companyList; // Liste für Firmeninformationen
  final LatLng currentPosition; // Aktuelle Position
  final Function(List<String>, List<String>, String, String?, List<String>) onFilterChanged; // Callback für Filteränderungen
  final Function(Map<String, dynamic>) onAddToRoute; // Callback für das Hinzufügen zur Route
  final List<Map<String, dynamic>> favoriteCompanies; // Favoriten-Liste
  final Function(Map<String, dynamic>) onToggleFavorite; // Callback zum Markieren/Entfernen von Favoriten

  const Sidebar({
    super.key,
    required this.isOpen,
    required this.onToggle,
    required this.companyList,
    required this.currentPosition,
    required this.onFilterChanged, // Callback übergeben
    required this.onAddToRoute, // Callback zum Hinzufügen zur Route
    required this.favoriteCompanies, // Favoriten-Liste übergeben
    required this.onToggleFavorite, // Callback zum Markieren/Entfernen von Favoriten
  });

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  List<String> industryOptions = [];
  List<String> employeeCountOptions = [];
  List<String> locationOptions = [];
  String _searchQuery = '';
  String? _selectedDistance;
  List<String> _selectedEmployeeCounts = [];
  List<String> _selectedIndustries = [];
  List<String> _selectedLocations = [];
  bool _isDataLoaded = false; // Flag to indicate data loading status

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFilterOptions();
    });
  }

  Future<void> _loadFilterOptions() async {
    try {
      final industries = await FilterService.getIndustryOptions();
      final employeeCounts = await FilterService.getEmployeeCountOptions();
      final locations = await FilterService.getLocationCountOptions();
      setState(() {
        industryOptions = industries;
        employeeCountOptions = employeeCounts;
        locationOptions = locations; // Setzt die Optionen für Orte

        // Set default selections if not already set
        _selectedEmployeeCounts = employeeCounts; // Default to all employee counts
        _selectedIndustries = industries; // Default to all industries
        _selectedLocations = locationOptions; // Default to all locations
        _isDataLoaded = true; // Data has been loaded
        // Callback aufrufen, um Filter an MapScreen zu übergeben
        widget.onFilterChanged(_selectedEmployeeCounts, _selectedIndustries, _searchQuery, _selectedDistance, _selectedLocations);
      });
    } catch (e) {
      print('Error loading filter options: $e');
    }
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  void _applyFilters() {
    // Callback aufrufen, wenn Filter angewendet werden
    widget.onFilterChanged(_selectedEmployeeCounts, _selectedIndustries, _searchQuery, _selectedDistance, _selectedLocations);
  }

  @override
  Widget build(BuildContext context) {
    // Überprüfen, ob die Daten geladen sind
    if (!_isDataLoaded) {
      return const Center(child: CircularProgressIndicator()); // Zeige einen Ladeindikator
    }

    // Sortiere die Firmen, wobei Favoriten zuerst erscheinen
    final sortedCompanies = List<Map<String, dynamic>>.from(widget.companyList);
    sortedCompanies.sort((a, b) {
      final isAFavorite = widget.favoriteCompanies.any((fav) => fav['Firma'] == a['Firma']);
      final isBFavorite = widget.favoriteCompanies.any((fav) => fav['Firma'] == b['Firma']);

      if (isAFavorite && !isBFavorite) {
        return -1;
      } else if (!isAFavorite && isBFavorite) {
        return 1;
      } else {
        return 0;
      }
    });

    final filteredCompanies = sortedCompanies.where((company) {
      final companyName = company['Firma'].toLowerCase();
      final searchQuery = _searchQuery.toLowerCase();
      final matchesSearchQuery = companyName.contains(searchQuery);

      final companyLatitude = double.tryParse(company['latitude'].toString()) ?? 0;
      final companyLongitude = double.tryParse(company['longitude'].toString()) ?? 0;
      final companyLocation = LatLng(companyLatitude, companyLongitude);

      final distance = _selectedDistance != null
          ? _calculateDistance(widget.currentPosition, companyLocation)
          : double.infinity; // Wenn keine Entfernung ausgewählt, keine Einschränkung

      final maxDistance = _selectedDistance != null
          ? double.parse(_selectedDistance!.split(' ')[0])
          : double.infinity;

      final matchesDistance = distance <= maxDistance;

      final employeeCountCategory = company['Mitarbeiterzahl_category']?.toString().trim() ?? '';
      final matchesEmployeeCount = _selectedEmployeeCounts.isEmpty ||
          _selectedEmployeeCounts.contains(employeeCountCategory);

      final industry = company['Branche']?.toString().trim() ?? '';
      final matchesIndustry = _selectedIndustries.isEmpty ||
          _selectedIndustries.contains(industry);

      final location = company['Ort']?.toString().trim() ?? ''; // Annahme: Ort als Feld im company Map
      final matchesLocation = _selectedLocations.isEmpty ||
          _selectedLocations.contains(location);

      // Nur wenn alle Bedingungen erfüllt sind
      return matchesSearchQuery && matchesDistance && matchesEmployeeCount && matchesIndustry && matchesLocation;
    }).toList();

    return Positioned(
      left: widget.isOpen ? 0 : -250, // Adjust based on sidebar width
      top: 0,
      bottom: 0,
      child: Container(
        width: 250,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Suche
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 6.0, left: 8.0, right: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Suche',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0), // Radius anpassen
                      borderSide: const BorderSide(color: Colors.black), // Farbe anpassen
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0), // Radius anpassen
                      borderSide: const BorderSide(color: Colors.black), // Farbe anpassen
                    ),
                    labelStyle: const TextStyle(color: Colors.black), // Farbe anpassen
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _applyFilters(); // Filter anwenden, wenn Suche geändert wird
                    });
                  },
                ),
              ),
              // Abstand
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _selectedDistance,
                  items: <String>['5 km', '10 km', '20 km', '50 km'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Entfernung',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0), // Radius anpassen
                      borderSide: const BorderSide(color: Colors.black), // Farbe anpassen
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0), // Radius anpassen
                      borderSide: const BorderSide(color: Colors.black), // Farbe anpassen
                    ),
                    labelStyle: const TextStyle(color: Colors.black), // Farbe anpassen
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedDistance = value;
                      _applyFilters(); // Filter anwenden, wenn Abstand geändert wird
                    });
                  },
                ),
              ),
              // Orte
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                child: CustomMultiselectDropDown(
                  options: locationOptions,
                  filterName: 'Ort',
                  selectedValues: _selectedLocations,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedLocations = values;
                      _applyFilters(); // Filter anwenden, wenn Orte geändert werden
                    });
                  },
                  labelText: 'Orte',
                ),
              ),
              // Mitarbeiterzahl
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                child: CustomMultiselectDropDown(
                  options: employeeCountOptions,
                  filterName: 'Mitarbeiter',
                  selectedValues: _selectedEmployeeCounts,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedEmployeeCounts = values;
                      _applyFilters(); // Filter anwenden, wenn Mitarbeiterzahlen geändert werden
                    });
                  },
                  labelText: 'Mitarbeiterzahl',
                ),
              ),
              // Branche
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
                child: CustomMultiselectDropDown(
                  options: industryOptions,
                  filterName: 'Branche',
                  selectedValues: _selectedIndustries,
                  onSelectionChanged: (values) {
                    setState(() {
                      _selectedIndustries = values;
                      _applyFilters(); // Filter anwenden, wenn Branchen geändert werden
                    });
                  },
                  labelText: 'Branche',
                ),
              ),
              // Liste der Firmen
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5, // Optional: Begrenze die Höhe der Liste
                child: ListView.builder(
                  itemCount: filteredCompanies.length,
                  itemBuilder: (context, index) {
                    final company = filteredCompanies[index];
                    final LatLng companyLocation = LatLng(
                      double.parse(company['latitude'].toString()),
                      double.parse(company['longitude'].toString()),
                    );

                    final distance = _calculateDistance(widget.currentPosition, companyLocation);

                    return CompanyCard(
                      company: company,
                      distance: distance,
                      onAddToRoute: widget.onAddToRoute,
                      onToggleFavorite: widget.onToggleFavorite, // Callback für Favoriten übergeben
                      isFavorite: widget.favoriteCompanies.any((fav) => fav['Firma'] == company['Firma']),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CompanyCard extends StatelessWidget {
  final Map<String, dynamic> company;
  final double distance;
  final Function(Map<String, dynamic>) onAddToRoute;
  final Function(Map<String, dynamic>) onToggleFavorite; // Callback für Favoriten
  final bool isFavorite; // Favoritenstatus

  const CompanyCard({
    super.key,
    required this.company,
    required this.distance,
    required this.onAddToRoute,
    required this.onToggleFavorite, // Callback übergeben
    required this.isFavorite, // Favoritenstatus übergeben
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container for the header with icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    company['Firma'],
                    style: bodyTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // IconButton with adjustments
                SizedBox(
                  height: 24, // Adjust height to align with text
                  width: 24,  // Adjust width to fit icon
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: primaryColor,
                    ),
                    onPressed: () {
                      onToggleFavorite(company); // Callback aufrufen, um zur Route hinzuzufügen
                      onAddToRoute(company);
                    },
                    padding: EdgeInsets.zero, // Entfernt Padding
                    constraints: const BoxConstraints(), // Entfernt Constraints
                    iconSize: 24, // Setzt die Größe des Icons
                    splashColor: Colors.transparent, // Entfernt den Splash-Effekt
                    highlightColor: Colors.transparent, // Entfernt den Highlight-Effekt
                    hoverColor: Colors.transparent, // Entfernt den Hover-Effekt
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0), // Abstand zwischen Header und weiteren Informationen
            Text(
              'Adresse: ${company['Adresse'] ?? 'Nicht verfügbar'}',
              style: bodyTextStyle.copyWith(fontSize: 12),
            ),
            Text(
              'Entfernung: ${distance.toStringAsFixed(2)} km',
              style: bodyTextStyle.copyWith(fontSize: 12),
            ),
            Text(
              'Mitarbeiter: ${company['Mitarbeiterzahl_category'] ?? 'Nicht verfügbar'}',
              style: bodyTextStyle.copyWith(fontSize: 12),
            ),
            Text(
              'Branche: ${company['Branche'] ?? 'Nicht verfügbar'}',
              style: bodyTextStyle.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}


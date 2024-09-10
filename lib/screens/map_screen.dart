import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_flutter_app/styles/styles.dart';
import 'package:my_flutter_app/widgets/custom_marker_layer.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';
import 'package:my_flutter_app/widgets/modal_window.dart'; // Importiere das Modal-Fenster
import 'package:my_flutter_app/widgets/sidebar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  List<dynamic> leads = [];
  List<Marker> markers = [];
  List<Marker> routeMarkers = []; // Marker für die Route
  LatLng? currentPosition;
  bool isLoading = true;
  bool isLocationLoaded = false;
  bool isLeadsLoaded = false;
  late AnimationController _animationController;
  late Animation<double> _borderWidthAnimation;
  bool isSidebarOpen = false;
  late SuperclusterMutableController _superclusterController;

  // Verwende ValueNotifier für zentrale Verwaltung der markierten Firmen
  final ValueNotifier<List<Map<String, dynamic>>> markedCompaniesNotifier = ValueNotifier([]);

  // Filterkriterien
  List<String> selectedEmployeeCategories = [];
  List<String> selectedIndustries = [];
  List<String> selectedLocations = []; // Neue Filterkriterien für Orte
  String _searchQuery = '';
  String? _selectedDistance;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeAnimation();
    _superclusterController = SuperclusterMutableController();
  }

  void _initializeAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _borderWidthAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadLeads() async {
    try {
      String jsonString = await rootBundle.loadString('assets/firmenadressen.json');
      List<dynamic> jsonData = jsonDecode(jsonString);
      if (jsonData.isNotEmpty) {
        setState(() {
          leads = jsonData;
          isLeadsLoaded = true;
          _checkLoadingStatus();
          _filterAndCreateMarkers(); // Marker erstellen, nachdem die Leads geladen wurden
        });
      } else {
        throw Exception('No leads data');
      }
    } catch (e) {
      print('Error loading leads: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      setState(() => isLoading = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        setState(() => isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied');
      setState(() => isLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPosition = LatLng(position.latitude, position.longitude);
      isLocationLoaded = true;
      _checkLoadingStatus();
      _loadLeads();
    });
  }

  void _filterAndCreateMarkers() {
    markers.clear();

    var filteredLeads = leads.where((lead) {
      final companyName = lead['Firma'].toLowerCase();
      final searchQuery = _searchQuery.toLowerCase();
      final matchesSearchQuery = companyName.contains(searchQuery);

      final companyLatitude = double.tryParse(lead['latitude'].toString()) ?? 0;
      final companyLongitude = double.tryParse(lead['longitude'].toString()) ?? 0;
      final companyLocation = LatLng(companyLatitude, companyLongitude);

      final distance = _selectedDistance != null
          ? _calculateDistance(currentPosition!, companyLocation)
          : double.infinity;

      final maxDistance = _selectedDistance != null
          ? double.parse(_selectedDistance!.split(' ')[0])
          : double.infinity;

      final matchesDistance = distance <= maxDistance;

      final employeeCountCategory = lead['Mitarbeiterzahl_category']?.toString().trim() ?? '';
      final matchesEmployeeCategory = selectedEmployeeCategories.isEmpty ||
          selectedEmployeeCategories.contains(employeeCountCategory);

      final industry = lead['Branche']?.toString().trim() ?? '';
      final matchesIndustry = selectedIndustries.isEmpty ||
          selectedIndustries.contains(industry);

      final location = lead['Adresse2']?.toString().trim() ?? ''; // Annahme: Ort als Feld im lead Map
      final matchesLocation = selectedLocations.isEmpty ||
          selectedLocations.contains(location);

      return matchesSearchQuery && matchesDistance && matchesEmployeeCategory && matchesIndustry && matchesLocation;
    }).toList();

    for (var lead in filteredLeads) {
      try {
                double latitude = double.parse(lead['latitude'].toString());
                double longitude = double.parse(lead['longitude'].toString());

        markers.add(
          Marker(
            point: LatLng(latitude, longitude),
            width: 150,
            height: 50,
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: markedCompaniesNotifier,
              builder: (context, markedCompanies, _) {
                return GestureDetector(
                  onTap: () {
                    _toggleFavorite(lead);
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Icon(
                          Icons.location_pin,
                          color: markedCompanies.contains(lead)
                              ? primaryColor
                              : const Color.fromARGB(255, 36, 95, 115),
                          size: 48,
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 1,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 100),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            lead['Firma'],
                            style: bodyTextStyle.copyWith(
                                fontSize: 10,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      } catch (e) {
        print('Error creating marker for ${lead['Firma']}: $e');
      }
    }

    if (currentPosition != null) {
      markers.add(
        Marker(
          point: currentPosition!,
          width: 40,
          height: 40,
          child: AnimatedBuilder(
            animation: _borderWidthAnimation,
            builder: (context, child) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0 + _borderWidthAnimation.value,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.near_me,
                    color: secondaryColor,
                    size: 14.0,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    print('Total markers created: ${markers.length}');

    // Aktualisiere den Controller nach dem Erstellen der Marker
    _superclusterController.replaceAll(markers);

    // Aktualisiere die UI
    setState(() {});
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const distance = Distance();
    return distance.as(LengthUnit.Kilometer, start, end);
  }

  void _checkLoadingStatus() {
    if (isLocationLoaded && isLeadsLoaded) {
      setState(() => isLoading = false);
    }
  }

  void _onFilterChanged(List<String> employeeCategories, List<String> industries, String searchQuery, String? distance, List<String> locations) {
    setState(() {
      selectedEmployeeCategories = employeeCategories;
      selectedIndustries = industries;
      _searchQuery = searchQuery;
      _selectedDistance = distance;
      selectedLocations = locations; // Filter für Orte aktualisieren
      _filterAndCreateMarkers(); // Filter und Marker aktualisieren
    });
  }

  void _onAddToRoute(Map<String, dynamic> company) {
    setState(() {
      routeMarkers.add(
        Marker(
          point: LatLng(
            double.parse(company['latitude'].toString()),
            double.parse(company['longitude'].toString()),
          ),
          width: 150,
          height: 50,
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                top: 0,
                child: Icon(Icons.location_pin, color: primaryColor, size: 48),
              ),
              Positioned(
                left: 40,
                top: 1,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 100),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    company['Firma'],
                    style: bodyTextStyle.copyWith(
                        fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _toggleFavorite(Map<String, dynamic> company) {
    if (markedCompaniesNotifier.value.contains(company)) {
      markedCompaniesNotifier.value = List.from(markedCompaniesNotifier.value)
        ..remove(company);
    } else {
      markedCompaniesNotifier.value = List.from(markedCompaniesNotifier.value)
        ..add(company);
    }

    _filterAndCreateMarkers();
  }

  @override
  void dispose() {
    _animationController.dispose();
    markedCompaniesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kartenansicht'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    center: currentPosition ?? const LatLng(51.9066, 8.3785),
                    zoom: 12,
                    onTap: (_, __) {},
                  ),
                  children: [
                    TileLayer(
                      tileProvider: CancellableNetworkTileProvider(),
                      urlTemplate:
                          "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                      subdomains: const ['a', 'b', 'c', 'd'],
                      retinaMode: true,
                    ),
                    CustomMarkerClusterLayer(
                      markers: markers,
                      controller: _superclusterController,
                    ),
                    MarkerLayer(
                      markers: routeMarkers,
                    ),
                  ],
                ),
                Sidebar(
                  isOpen: isSidebarOpen,
                  companyList: leads.map((lead) {
                    return {
                      'Firma': lead['Firma'],
                      'Adresse': lead['Adresse'],
                      'Mitarbeiterzahl_category': lead['Mitarbeiterzahl_category'],
                      'Branche': lead['Branche'],
                      'latitude': lead['latitude'],
                      'longitude': lead['longitude'],
                      'Ort': lead['Adresse2'], // Annahme: Ort als Feld im lead Map
                    };
                  }).toList(),
                  currentPosition: currentPosition ?? const LatLng(0, 0),
                  onToggle: () {
                    setState(() {
                      isSidebarOpen = !isSidebarOpen;
                    });
                  },
                  onFilterChanged: _onFilterChanged, // Callback übergeben
                  onAddToRoute: _onAddToRoute, // Callback zum Hinzufügen zur Route übergeben
                  favoriteCompanies: markedCompaniesNotifier.value,
                  onToggleFavorite: _toggleFavorite, // Callback zum Markieren der Firma übergeben
                ),
              Positioned(
                bottom: 16,
                right: 76, // Positioniere den Herz-Button
                child: FloatingActionButton(
                  heroTag: 'favorite_button', // Eindeutiger Hero-Tag
                  onPressed: () {
                    showMarkedCompaniesDialog(
                      context,
                      markedCompaniesNotifier.value,
                      _toggleFavorite,
                      currentPosition!,
                    ); // Zeige das Modal-Fenster
                  },
                  backgroundColor: primaryColor,
                  child: const Icon(Icons.favorite, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  heroTag: 'menu_button', // Ein anderer eindeutiger Hero-Tag
                  onPressed: () {
                    setState(() {
                      isSidebarOpen = !isSidebarOpen;
                    });
                  },
                  backgroundColor: primaryColor,
                  child: const Icon(Icons.menu, color: secondaryColor),
                ),
              ),

              ],
            ),
    );
  }
}

       

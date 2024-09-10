import 'dart:convert';
import 'package:flutter/services.dart';

class FilterService {
  static Future<List<String>> getIndustryOptions() async {
    final jsonString = await rootBundle.loadString('assets/firmenadressen.json');
    final List<dynamic> data = jsonDecode(jsonString);

    final Set<String> industries = {};
    for (var item in data) {
      industries.add(item['Branche'] ?? 'Nicht verfügbar');
    }
    return industries.toList()..sort();
  }

  static Future<List<String>> getEmployeeCountOptions() async {
    final jsonString = await rootBundle.loadString('assets/firmenadressen.json');
    final List<dynamic> data = jsonDecode(jsonString);

    final Set<String> employeeCounts = {};
    for (var item in data) {
      employeeCounts.add(item['Mitarbeiterzahl_category'] ?? 'Nicht verfügbar');
    }
    return employeeCounts.toList()..sort();
  }

  static Future<List<String>> getLocationCountOptions() async {
    final jsonString = await rootBundle.loadString('assets/firmenadressen.json');
    final List<dynamic> data = jsonDecode(jsonString);

    final Set<String> locationCounts = {};
    for (var item in data) {
      locationCounts.add(item['Adresse2'] ?? 'Nicht verfügbar');
    }
    return locationCounts.toList()..sort();
  }
}

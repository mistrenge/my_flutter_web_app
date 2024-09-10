import 'package:my_flutter_app/models/lead.dart';

class LeadService {
  List<Lead> getLeads() {
    return [
      Lead(name: 'Firma A', address: 'Adresse A', industry: 'Industrie A', latitude: 52.5200, longitude: 13.4050),
      Lead(name: 'Firma B', address: 'Adresse B', industry: 'Industrie B', latitude: 48.8566, longitude: 2.3522),
      // Weitere Leads hinzufügen
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:my_flutter_app/models/lead.dart';

class LeadDetailScreen extends StatelessWidget {
  final Lead lead;

  const LeadDetailScreen({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(lead.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Adresse: ${lead.address}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Branche: ${lead.industry}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Koordinaten: ${lead.latitude}, ${lead.longitude}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

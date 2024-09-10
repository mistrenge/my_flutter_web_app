import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class Cluster {
  final LatLng position;
  final List<Marker> markers;

  Cluster(this.position, this.markers);

  int get markerCount => markers.length;
}

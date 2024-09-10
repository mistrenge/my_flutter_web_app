import 'package:latlong2/latlong.dart';
import 'cluster.dart';
import 'package:flutter_map/flutter_map.dart';

List<Cluster> clusterMarkers(List<Marker> markers, double radius) {
  final clusters = <Cluster>[];
  const distance = Distance();

  for (var marker in markers) {
    bool clustered = false;
    final markerPosition = marker.point;

    for (var cluster in clusters) {
      final clusterPosition = cluster.position;
      final clusterDistance = distance.as(LengthUnit.Kilometer, markerPosition, clusterPosition);

      if (clusterDistance < radius) {
        cluster.markers.add(marker);
        clustered = true;
        break;
      }
    }

    if (!clustered) {
      clusters.add(Cluster(markerPosition, [marker]));
    }
  }

  return clusters;
}

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';


class CustomMarkerClusterLayer extends StatefulWidget {
  final List<Marker> markers;
  final SuperclusterMutableController controller;

  const CustomMarkerClusterLayer({
    super.key,
    required this.markers,
    required this.controller,
  });

  @override
  _CustomMarkerClusterLayerState createState() => _CustomMarkerClusterLayerState();
}

class _CustomMarkerClusterLayerState extends State<CustomMarkerClusterLayer> {
  @override
  void initState() {
    super.initState();
    widget.controller.replaceAll(widget.markers);
  }

  @override
  void didUpdateWidget(covariant CustomMarkerClusterLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.markers != widget.markers) {
      widget.controller.replaceAll(widget.markers);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SuperclusterLayer.mutable(
      initialMarkers: widget.markers,
      indexBuilder: IndexBuilders.rootIsolate,
      controller: widget.controller,
      moveMap: (center, zoom) {
        final mapController = MapController.of(context);
        mapController.move(center, zoom);
            },
      clusterWidgetSize: const Size(40, 40),
      builder: (context, position, markerCount, extraClusterData) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color.fromARGB(255, 184, 200, 211),
          ),
          child: Center(
            child: Text(
              markerCount.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}


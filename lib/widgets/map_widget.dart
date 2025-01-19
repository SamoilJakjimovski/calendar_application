import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final LatLng location;

  MapWidget({required this.location});

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: location, zoom: 15),
      markers: {
        Marker(
          markerId: MarkerId('event_location'),
          position: location,
        )
      },
    );
  }
}

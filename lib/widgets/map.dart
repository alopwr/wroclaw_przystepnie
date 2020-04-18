import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wroclaw_przystepnie/providers/places.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    return GoogleMap(
      onMapCreated: places.onMapCreated,
      markers: places.markers,
      onTap: (_) {
        places.hideDetails();
      },
      buildingsEnabled: true,
      compassEnabled: false,
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: LatLng(51.106715, 17.031645),
        zoom: 15,
      ),
    );
    // onTap: () => places.showDetails(1),
    // onDoubleTap: () => places.hideDetails(),
  }
}

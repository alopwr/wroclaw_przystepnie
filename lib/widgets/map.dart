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
      initialCameraPosition: const CameraPosition(
        target: LatLng(10.283203123568985, 4.30259107652187),
        zoom: 7.0,
      ),
    );
    // onTap: () => places.showDetails(1),
    // onDoubleTap: () => places.hideDetails(),
  }
}

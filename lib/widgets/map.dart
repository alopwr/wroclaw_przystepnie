import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import '../providers/user_location.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    var user = Provider.of<UserLocationManager>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 95),
      child: GoogleMap(
        onMapCreated: places.onMapCreated,
        markers: places.markers,
        onTap: (_) {
          places.showMenu();
        },
        buildingsEnabled: true,
        compassEnabled: true,
        mapToolbarEnabled: true,
        zoomControlsEnabled: false,
        myLocationEnabled: user.enabledAndAllowedLocation ? true : false,
        myLocationButtonEnabled: false,
        tiltGesturesEnabled: false,
        padding: EdgeInsets.only(
            right: 70, bottom: 17, top: MediaQuery.of(context).padding.top),
        initialCameraPosition: const CameraPosition(
          target: LatLng(51.106715, 17.031645),
          zoom: 15,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';

import 'places.dart';

class UserLocationManager with ChangeNotifier {
  UserLocationManager({this.places});
  Places places;

  PermissionStatus permission;
  ServiceStatus serviceStatus;

  bool get enabledAndAllowedLocation =>
      permission == PermissionStatus.granted &&
      serviceStatus == ServiceStatus.enabled;

  bool get displayWarningIcon =>
      !enabledAndAllowedLocation && permission != null && serviceStatus != null;

  Future<void> permissionHandling() async {
    permission = await LocationPermissions().checkPermissionStatus(
        level: LocationPermissionLevel.locationWhenInUse);
    if (permission != PermissionStatus.granted)
      permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationWhenInUse);
    serviceStatus = await LocationPermissions()
        .checkServiceStatus(level: LocationPermissionLevel.locationWhenInUse);
    notifyListeners();
  }

  Future<void> focusOnUser() async {
    if (!enabledAndAllowedLocation) return;
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.locationWhenInUse);
    places.panelController.close();
    await places.googleMapsController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        ),
      ),
    );
  }
}

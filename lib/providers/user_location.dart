import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';

import '../helpers/locator.dart';
import '../widgets/global_dialogs.dart';
import '../widgets/location_permission_info_popup.dart';
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
    if (permission != PermissionStatus.granted) {
      await showDialog(
          context:
              locator<GlobalKey<GlobalContextProviderState>>().currentContext,
          builder: (context) => LocationPermissionInfoPopup());
      permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationWhenInUse);
    }
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
    places.scrollController.jumpTo(0);
    await places?.googleMapsController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16,
        ),
      ),
    );
  }

  Future<bool> placeDistanceValidation(LatLng location) async {
    await permissionHandling();
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        locationPermissionLevel: GeolocationPermission.locationWhenInUse);
    var distance = await Geolocator().distanceBetween(location.latitude,
        location.longitude, position.latitude, position.longitude);

    if (distance > 50) return false;
    return true;
  }
}

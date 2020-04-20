import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../helpers/http_helper.dart';
import 'auth.dart';
import 'place.dart';
import 'track.dart';

class Places with ChangeNotifier {
  Places({this.auth});
  Auth auth;
  final panelController = PanelController();
  GoogleMapController googleMapsController;

  List<Place> _places = [];
  Track currentTrack;

  List<Place> get places => [..._places];

  Set<Marker> get markers =>
      visiblePlaces.map((placeElement) => placeElement.marker).toSet();

  List<Place> get visiblePlaces {
    if (_visiblePlacesIds == null)
      return places;
    else
      return places
          .where((element) => _visiblePlacesIds.contains(element.id))
          .toList();
  }

  List<int> get _visiblePlacesIds => currentTrack?.places;

  Future<void> fetchPlaces({bool rebuild = true}) async {
    var placesJson = await HttpHelper.fetchPlaces(auth.headers);
    _places = placesJson
        .map((jsonMap) => Place.fromJson(jsonMap, showDetails))
        .toList();
    if (rebuild) notifyListeners();
  }

  void setVisiblePlacesFilter(Track track) {
    currentTrack = track;
    panelController.close();
    final bounds = visibleMarkersBounds;
    googleMapsController.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: bounds['southwest'],
        northeast: bounds['northeast'],
      ),
      0,
    ));
    notifyListeners();
  }

  void clearFilter() {
    currentTrack = null;
    notifyListeners();
  }

  int _activePlaceId;

  bool get showDetailView => _activePlaceId != null;

  void showDetails(int id) {
    if (id == null) return;
    panelController.close();
    _activePlaceId = id;
    googleMapsController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: activePlace.location,
          zoom: 16,
        ),
      ),
    );
    notifyListeners();
  }

  void showMenu() {
    _activePlaceId = null;
    panelController.close();
    notifyListeners();
  }

  Place get activePlace {
    if (_activePlaceId == null) return null;
    return places.firstWhere((element) => element.id == _activePlaceId);
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapsController = controller;
  }

  List<int> get placesIds => places.map((e) => e.id).toList();

  void detailRandom() =>
      showDetails(placesIds[Random().nextInt(placesIds.length)]);

  Map<String, LatLng> get visibleMarkersBounds {
    List<double> lats = [];
    List<double> longs = [];

    visiblePlaces.forEach((element) {
      lats.add(element.location.latitude);
      longs.add(element.location.longitude);
    });

    return {
      "southwest": LatLng(lats.reduce(min), longs.reduce(min)),
      "northeast": LatLng(lats.reduce(max), longs.reduce(max))
    };
  }
}

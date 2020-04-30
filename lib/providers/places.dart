import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../helpers/http_helper.dart';
import '../widgets/map_style.dart';
import 'auth.dart';
import 'place.dart';
import 'track.dart';

class Places with ChangeNotifier {
  Places({this.auth});
  Auth auth;

  final panelController = PanelController();
  GoogleMapController googleMapsController;
  ScrollController _scrollController;
  bool refreshingBadge;
  bool offlineBadge = false;

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

  Future<void> fetchPlaces() async {
    var placesJson = await HttpHelper.fetchPlaces(auth.headers);
    await Future.delayed(Duration(seconds: 5));
    parsePlaces(placesJson);
  }

  Future<void> refreshPlaces() async {
    try {
      await fetchPlaces();
    } on SocketException {
      offlineBadge = true;
    }
    refreshingBadge = false;
    notifyListeners();
  }

  Future<void> cachedPlaces() async {
    var cache = Hive.box("cacheJson").get('placesJson');
    if (cache == null) {
      refreshingBadge = false;
      await fetchPlaces();
      notifyListeners();
      return;
    }
    parsePlaces(List<Map<String, dynamic>>.from(json.decode(cache)));
    notifyListeners();
    refreshPlaces();
  }

  void parsePlaces(List<Map<String, dynamic>> jsonMaps) {
    _places = jsonMaps
        .map((jsonMap) => Place.fromJson(jsonMap, showDetails))
        .toList();
    _places = _places.reversed.toList();
  }

  void setVisiblePlacesFilter(Track track) {
    currentTrack = track;
    panelController.close();
    scrollController.jumpTo(0);
    notifyListeners();
    focusOnVisible();
  }

  void clearFilter({bool close = false, bool zoomOut = false}) {
    currentTrack = null;
    notifyListeners();
    if (close) {
      panelController.close();
      scrollController.jumpTo(0);
    }
    if (zoomOut) focusOnVisible();
  }

  void focusOnVisible() {
    final bounds = visibleMarkersBounds;
    googleMapsController?.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: bounds['southwest'],
        northeast: bounds['northeast'],
      ),
      30,
    ));
  }

  int _activePlaceId;

  bool get showDetailView => _activePlaceId != null;

  void showDetails(int id) {
    if (id == null) return;
    _activePlaceId = id;
    googleMapsController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: activePlace.location,
          zoom: 16,
        ),
      ),
    );
    notifyListeners();
    panelController.animatePanelToSnapPoint();
  }

  void showMenu() {
    _activePlaceId = null;
    panelController.close();
    scrollController.jumpTo(0);
    notifyListeners();
  }

  void showMenuAndZoomOut() {
    showMenu();
    focusOnVisible();
  }

  Place get activePlace {
    if (_activePlaceId == null) return null;
    return places.firstWhere((element) => element.id == _activePlaceId);
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapsController = controller;
    googleMapsController.setMapStyle(mapStyle);
    Future.delayed(Duration(milliseconds: 100), focusOnVisible);
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

  Future<bool> markAsVisited(int id, [BuildContext context]) async {
    var success = await HttpHelper.markAsVisited(id, auth.headers, context);
    if (!success) return false;

    var placeId = places.indexWhere((element) => element.id == id);
    _places[placeId] = places[placeId]..isVisited = true;
    _places[placeId].refreshMarker(showDetails);
    refreshingBadge = true;

    notifyListeners();
    refreshPlaces();
    return true;
  }

  set scrollController(ScrollController value) {
    _scrollController = value;
  }

  ScrollController get scrollController => _scrollController;
}

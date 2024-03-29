import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../helpers/http_helper.dart';
import '../helpers/locator.dart';
import '../main.dart';
import '../widgets/global_dialogs.dart';
import '../widgets/map_style.dart';
import '../widgets/wrong_order_popup.dart';
import 'auth.dart';
import 'path.dart';
import 'paths.dart';
import 'place.dart';

class Places with ChangeNotifier {
  Places({this.auth});
  Auth auth;

  final panelController = PanelController();
  GoogleMapController googleMapsController;
  ScrollController scrollController;
  bool refreshingBadge;
  bool offlineBadge = false;

  List<Place> _places = [];
  Path currentPath;

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

  List<int> get _visiblePlacesIds => currentPath?.places;

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
    Future.delayed(Duration.zero, notifyListeners);
  }

  Future<void> cachedPlaces() async {
    var cache = Hive.box("cacheJson").get('placesJson');
    if (cache == null) {
      refreshingBadge = false;
      await fetchPlaces();
      Future.delayed(Duration.zero, notifyListeners);
      return;
    }
    parsePlaces(List<Map<String, dynamic>>.from(json.decode(cache)));
    Future.delayed(Duration.zero, notifyListeners);
    refreshPlaces();
  }

  void parsePlaces(List<Map<String, dynamic>> jsonMaps) {
    _places = jsonMaps
        .map((jsonMap) => Place.fromJson(jsonMap, showDetails))
        .toList();
    _places = _places.toList();
  }

  void setVisiblePlacesFilter(Path path) {
    currentPath = path;
    panelController.close();
    scrollController.jumpTo(0);
    notifyListeners();
    focusOnVisible();
  }

  void clearFilter({bool close = false, bool zoomOut = false}) {
    currentPath = null;
    notifyListeners();
    if (close) {
      panelController.close();
      scrollController.jumpTo(0);
    }
    if (zoomOut) focusOnVisible();
  }

  void focusOnVisible() {
    final bounds = visibleMarkersBounds;
    if (bounds == null) return;
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

  void showDetails(int id) async {
    if (id == null) return;

    var place = places.firstWhere((element) => element.id == id);
    if (place.wrongOrder) {
      var result = await showDialog(
          context:
              locator<GlobalKey<GlobalContextProviderState>>().currentContext,
          builder: (context) => WrongOrderPopup());
      if (result == null) return;
      if (result == DialogOptions.showProperPoint) {
        showDetails(locator<Paths>().properPoint(id).id);
        return;
      }
    }

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
    Future.delayed(Duration(milliseconds: 300), focusOnVisible);
  }

  List<int> get placesIds => places.map((e) => e.id).toList();

  List<int> get easilyAccesedPlacesIds =>
      places.where((e) => !e.wrongOrder).map((e) => e.id).toList();

  void detailRandom() => showDetails(
      easilyAccesedPlacesIds[Random().nextInt(easilyAccesedPlacesIds.length)]);

  Map<String, LatLng> get visibleMarkersBounds {
    List<double> lats = [];
    List<double> longs = [];
    if (visiblePlaces == null || visiblePlaces.length == 0) return null;
    visiblePlaces?.forEach((element) {
      lats.add(element.location.latitude);
      longs.add(element.location.longitude);
    });

    return {
      "southwest": LatLng(lats.reduce(min), longs.reduce(min)),
      "northeast": LatLng(lats.reduce(max), longs.reduce(max))
    };
  }

  Future<void> markAsVisited(int id, [BuildContext context]) async {
    var placeId = places.indexWhere((element) => element.id == id);
    _places[placeId] = places[placeId]..isVisited = true;
    _places[placeId].refreshMarker(showDetails);
    refreshingBadge = true;

    notifyListeners();

    HttpHelper.markAsVisited(id, auth.headers, context)
        .then(
      (value) => refreshPlaces(),
    )
        .catchError((e) {
      reportSentryError(e, null);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Niepowodzenie"),
                content: const Text(
                    "Niestety nie udało się oznanaczyć miejsca jako odwiedzione"),
                actions: <Widget>[
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    });
  }

  void allowNext(int nextId) {
    var placeId = places.indexWhere((element) => element.id == nextId);
    _places[placeId] = places[placeId]..wrongOrder = false;
  }
}

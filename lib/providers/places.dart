import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/http_helper.dart';
import '../screens/map_screen.dart';
import 'auth.dart';
import 'place.dart';

final mapScreenKey = GlobalKey<MapScreenState>();

class Places with ChangeNotifier {
  Places({this.auth});
  Auth auth;

  List<Place> _places = [];
  List<int> _visiblePlacesIds;

  GoogleMapController googleMapsController;

  List<Place> get places => [..._places];
  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

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

  Future<void> fetchPlaces({bool rebuild = true}) async {
    var placesJson = await HttpHelper.fetchPlaces(auth.headers);
    _places = placesJson
        .map((jsonMap) => Place.fromJson(jsonMap, showDetails))
        .toList();
    if (rebuild) notifyListeners();
  }

  void setVisiblePlacesFilter(List<int> visibleIds) {
    _visiblePlacesIds = visibleIds;
    notifyListeners();
  }

  void clearFilter() {
    _visiblePlacesIds = null;
    notifyListeners();
  }

  int _activePlaceId;

  bool get showDetailView => _activePlaceId != null;

  void showDetails(int id) {
    if (id == null) return;
    _activePlaceId = id;
    mapScreenKey.currentState?.showPanel();
    notifyListeners();
  }

  void hideDetails() {
    mapScreenKey.currentState?.hidePanel();
    _activePlaceId = null;
  }

  Place get activePlace {
    if (_activePlaceId == null) return null;
    return places.firstWhere((element) => element.id == _activePlaceId);
  }

  void onMapCreated(GoogleMapController controller) {
    googleMapsController = controller;
  }
}

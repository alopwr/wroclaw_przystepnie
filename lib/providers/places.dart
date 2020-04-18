import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

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

  List<Place> get places => [..._places];

  List<Place> get visiblePlaces {
    if (_visiblePlacesIds == null)
      return places;
    else
      return places
          .where((element) => _visiblePlacesIds.contains(element.id))
          .toList();
  }

  Future<void> fetchPlaces() async {
    var placesJson = await HttpHelper.fetchPlaces(auth.headers);
    _places = placesJson.map((jsonMap) => Place.fromJson(jsonMap));
  }

  Future<void> refreshPlaces() async {
    await fetchPlaces();
    notifyListeners();
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
}

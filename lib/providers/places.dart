import 'package:flutter/foundation.dart';
import 'package:wroclaw_przystepnie/helpers/http_helper.dart';

import 'auth.dart';
import 'place.dart';

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
}

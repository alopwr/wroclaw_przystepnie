import '../helpers/locator.dart';
import 'place.dart';
import 'places.dart';

class Track {
  Track.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.description = jsonMap['description'];
    this.progress = jsonMap['progress'].toDouble();
    this.places = List<int>.from(jsonMap['place_set']);
    this.enforceOrder = jsonMap['enforce_order'];
  }
  String name;
  int id;
  String description;
  double progress;
  List<int> places;
  bool enforceOrder;

  void increaseVisited() =>
      progress = ((progress * places.length) + 1) / places.length;

  void allowNext(int id) {
    if (!enforceOrder) return;
    var nextId = places.indexOf(id) + 1;
    locator<Places>().allowNext(places[nextId]);
  }

  String get progressLabel => "${(progress * 100).toInt()}%";

  Place get properPoint {
    final placesProvider = locator<Places>();
    return placesProvider.places
        .where((element) => places.contains(element.id))
        .lastWhere((element) => !element.wrongOrder);
  }

  Place get nextPoint {
    final placesProvider = locator<Places>();
    var current = placesProvider.activePlace;
    if (current == null) return null;
    if (places.last == current.id) return null;
    var nextId = places[places.indexOf(current.id) + 1];
    return placesProvider.places.firstWhere((element) => element.id == nextId);
  }
  
  Place get previousPoint {
    final placesProvider = locator<Places>();
    var current = placesProvider.activePlace;
    if (current == null) return null;
    if (places.first == current.id) return null;
    var previousId = places[places.indexOf(current.id) - 1];
    return placesProvider.places.firstWhere((element) => element.id == previousId);
  }
}

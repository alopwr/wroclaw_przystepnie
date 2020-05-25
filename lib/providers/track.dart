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

  String get progressLabel => "${(progress * 100).toInt()}%";

  Place get properPoint {
    final placesProvider = locator<Places>();
    return placesProvider.places
        .where((element) => places.contains(element.id))
        .lastWhere((element) => !element.wrongOrder);
  }
}

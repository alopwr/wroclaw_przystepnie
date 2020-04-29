class Track {
  Track.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.description = jsonMap['description'];
    this.progress = jsonMap['progress'].toDouble();
    this.places = List<int>.from(jsonMap['place_set']);
  }
  String name;
  int id;
  String description;
  double progress;
  List<int> places;
  void increaseVisited() =>
      progress = ((progress * places.length) + 1) / places.length;

  String get progressLabel => "${(progress * 100).toInt()}%";
}

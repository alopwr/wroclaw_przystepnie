class Track {
  Track.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.description = jsonMap['description'];
    this.places = jsonMap['place_set'];
  }
  String name;
  int id;
  String description;
  List<int> places;
}

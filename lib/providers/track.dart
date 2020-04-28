class Track {
  Track.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.description = jsonMap['description'];
    this.places = List<int>.from(jsonMap['place_set']);
  }
  String name;
  int id;
  String description;
  List<int> places;
  void increaseVisited() {
    
  }
}

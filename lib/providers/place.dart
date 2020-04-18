import 'package:flutter/foundation.dart';

enum MediaType { image, iound, video }

class Location {
  Location({@required this.latitude, @required this.longitude});
  Location.fromList(List<double> list) {
    this.latitude = list[0];
    this.longitude = list[1];
  }

  double latitude;
  double longitude;
}

class Media {
  Media({@required this.id, @required this.url, @required this.type});

  Media.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.url = jsonMap['file'];
    this.type = MediaType.image;
  }

  int id;
  String url;
  MediaType type;
}

class Place with ChangeNotifier {
  Place({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.location,
    @required this.mediaSet,
  });

  Place.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.description = jsonMap['description'];
    this.location = Location.fromList(jsonMap['location']['coordinates']);
    this.mediaSet = (jsonMap['media_set'] as List<Map<String, dynamic>>)
        .map((e) => Media.fromJson(e))
        .toList();
  }

  int id;
  String name;
  String description;
  Location location;
  List<Media> mediaSet;
}

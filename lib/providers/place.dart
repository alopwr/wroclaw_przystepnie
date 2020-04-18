import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MediaType { image, audio, video }

class Media {
  Media.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.url = jsonMap['file'];
    this.type = jsonMap['type'] == 'image'
        ? MediaType.image
        : jsonMap['type'] == 'audio' ? MediaType.audio : MediaType.video;
  }

  int id;
  String url;
  MediaType type;
}

class Place with ChangeNotifier {
  Place.fromJson(Map<String, dynamic> jsonMap, Function(int) showDetails) {
    this.id = jsonMap['id'];
    this.name = jsonMap['name'];
    this.description = jsonMap['description'];
    this.location = LatLng(jsonMap['location']['coordinates'][0],
        jsonMap['location']['coordinates'][1]);
    this.mediaSet = List<Map<String, dynamic>>.from(jsonMap['media_set'])
        .map((e) => Media.fromJson(e))
        .toList();
    this.marker = Marker(
      markerId: MarkerId("marker-place-id-$id"),
      position: location,
      onTap: () {
        showDetails(id);
      },
    );
  }

  int id;
  String name;
  String description;
  LatLng location;
  List<Media> mediaSet;
  Marker marker;
}
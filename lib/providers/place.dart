import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../helpers/widget_to_image_converter.dart';

enum MediaType { image, audio, video }

class Media {
  Media.fromJson(Map<String, dynamic> jsonMap) {
    this.id = jsonMap['id'];
    this.url = jsonMap['file'];
    this.name = jsonMap['name'];
    this.type = jsonMap['type'] == 'image'
        ? MediaType.image
        : jsonMap['type'] == 'audio' ? MediaType.audio : MediaType.video;
  }

  int id;
  String url;
  String name;
  MediaType type;

  bool get isImage => type == MediaType.image;
  String get heroTag => "heromediatag-$id";
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
    this.isVisited = jsonMap['visited'];
    this.marker = Marker(
      markerId: MarkerId("marker-place-id-$id"),
      position: location,
      onTap: () {
        showDetails(id);
      },
      icon: isVisited ? WidgetToImageConverter.tickedMarkerIcon : null,
    );
    this.wrongOrder = jsonMap['wrong_order'];
  }

  int id;
  String name;
  String description;
  LatLng location;
  List<Media> mediaSet;
  Marker marker;
  bool isVisited;
  bool wrongOrder;

  List<Media> get mediaGallerySet =>
      mediaSet.where((element) => element.type == MediaType.image).toList();

  List<Media> get audioSet =>
      mediaSet.where((element) => element.type == MediaType.audio).toList();

  void refreshMarker(Function(int) showDetails) {
    this.marker = Marker(
      markerId: MarkerId("marker-place-id-$id"),
      position: location,
      onTap: () {
        showDetails(id);
      },
      icon: isVisited ? WidgetToImageConverter.tickedMarkerIcon : null,
    );
    notifyListeners();
  }
}

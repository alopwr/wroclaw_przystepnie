import 'package:flutter/foundation.dart';

import '../helpers/http_helper.dart';
import 'auth.dart';
import 'track.dart';

class Tracks with ChangeNotifier {
  Tracks({this.auth});
  Auth auth;

  List<Track> _tracks = [];

  List<Track> get tracks => [..._tracks];

  Future<void> fetchTracks({bool rebuild = true}) async {
    var placesJson = await HttpHelper.fetchTracks(auth.headers);
    _tracks = placesJson.map((jsonMap) => Track.fromJson(jsonMap)).toList();
    if (rebuild) notifyListeners();
  }
}

import 'package:flutter/foundation.dart';

import '../helpers/http_helper.dart';
import 'auth.dart';
import 'track.dart';

class Tracks with ChangeNotifier {
  Tracks({this.auth});
  Auth auth;

  List<Track> _tracks;

  List<Track> get tracks => _tracks != null ? [..._tracks] : null;

  Future<void> fetchTracks({bool rebuild = true}) async {
    var tracksJson = await HttpHelper.fetchTracks(auth.headers);
    _tracks = tracksJson.map((jsonMap) => Track.fromJson(jsonMap)).toList();
    _tracks = _tracks.reversed.toList();
    if (rebuild) notifyListeners();
  }

  Future<void> getTracks() async {
    if (tracks == null) await fetchTracks();
    return tracks;
  }
}

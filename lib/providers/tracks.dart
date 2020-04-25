import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../helpers/http_helper.dart';
import 'auth.dart';
import 'track.dart';

class Tracks with ChangeNotifier {
  Tracks({this.auth});
  Auth auth;

  List<Track> _tracks;

  bool refreshingBadge;
  bool offlineBadge = false;

  List<Track> get tracks => _tracks != null ? [..._tracks] : null;

  Future<void> fetchTracks({bool rebuild = true}) async {
    var tracksJson = await HttpHelper.fetchTracks(auth.headers);
    await Future.delayed(Duration(seconds: 5));
    parseJson(tracksJson);
  }

  Future<void> getTracks() async {
    if (tracks == null) await cachedTracks();
    return tracks;
  }

  Future<void> cachedTracks() async {
    var cache = Hive.box("cacheJson").get('tracksJson');
    if (cache == null) {
      refreshingBadge = false;
      await fetchTracks();
      notifyListeners();
      return;
    }
    parseJson(List<Map<String, dynamic>>.from(json.decode(cache)));
    notifyListeners();
    refreshTracks();
  }

  Future<void> refreshTracks() async {
    try {
      await fetchTracks();
    } on SocketException {
      offlineBadge = true;
    }
    refreshingBadge = false;
    notifyListeners();
  }

  void parseJson(List<Map<String, dynamic>> tracksJson) {
    _tracks = tracksJson.map((jsonMap) => Track.fromJson(jsonMap)).toList();
    _tracks = _tracks.reversed.toList();
  }
}

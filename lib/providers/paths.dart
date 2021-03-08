import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../helpers/http_helper.dart';
import 'auth.dart';
import 'place.dart';
import 'path.dart';

class Paths with ChangeNotifier {
  Paths({this.auth});
  Auth auth;

  List<Path> _paths;

  bool refreshingBadge;
  bool offlineBadge = false;

  List<Path> get paths => _paths != null ? [..._paths] : null;

  Future<void> fetchPaths({bool rebuild = true}) async {
    var pathsJson = await HttpHelper.fetchPaths(auth.headers);
    await Future.delayed(Duration(seconds: 5));
    parseJson(pathsJson);
  }

  Future<void> getPaths() async {
    if (paths == null) await cachedPaths();
    return paths;
  }

  Future<void> cachedPaths() async {
    var cache = Hive.box("cacheJson").get('pathsJson');
    if (cache == null) {
      refreshingBadge = false;
      await fetchPaths();
      Future.delayed(Duration.zero, notifyListeners);
      return;
    }
    parseJson(List<Map<String, dynamic>>.from(json.decode(cache)));
    Future.delayed(Duration.zero, notifyListeners);
    refreshPaths();
  }

  Future<void> refreshPaths() async {
    try {
      await fetchPaths();
    } on SocketException {
      offlineBadge = true;
    }
    refreshingBadge = false;
    Future.delayed(Duration.zero, notifyListeners);
  }

  void parseJson(List<Map<String, dynamic>> pathsJson) {
    _paths = pathsJson.map((jsonMap) => Path.fromJson(jsonMap)).toList();
    _paths = _paths.toList();
  }

  void markAsVisited(int placeId) {
    var path = paths.firstWhere((element) => element.places.contains(placeId));
    path.increaseVisited();
    path.allowNext(placeId);
    notifyListeners();
    refreshPaths();
  }

  Path properPath(int id) =>
      paths.firstWhere((element) => element.places.contains(id));

  Place properPoint(int id) => properPath(id).properPoint;
}

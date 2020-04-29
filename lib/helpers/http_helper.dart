import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/tracks.dart';

const API_MASTER_URL = "https://wroclaw-przystepnie.herokuapp.com/v0";

class HttpHelper {
  static Future<List<Map<String, dynamic>>> fetchPlaces(
      Map<String, String> headers) async {
    var url = "$API_MASTER_URL/places/";
    var response = await http.get(
      url,
      headers: headers,
    );
    var text = utf8.decode(response.bodyBytes);
    Hive.box('cacheJson').put('placesJson', text);
    return List<Map<String, dynamic>>.from(json.decode(text));
  }

  static Future<List<Map<String, dynamic>>> fetchTracks(
      Map<String, String> headers) async {
    var url = "$API_MASTER_URL/paths/";
    var response = await http.get(
      url,
      headers: headers,
    );
    var text = utf8.decode(response.bodyBytes);
    Hive.box('cacheJson').put("tracksJson", text);
    return List<Map<String, dynamic>>.from(json.decode(text));
  }

  static Future<bool> markAsVisited(int id, Map<String, String> headers,
      [BuildContext context]) async {
    var url = "$API_MASTER_URL/visits/";
    Response response;
    try {
      response = await http.post(
        url,
        headers: headers,
        body: '{"place" : "$id"}',
      );
    } on SocketException {
      return false;
    }

    var text = utf8.decode(response.bodyBytes);
    if (text.startsWith("IntegrityError")) {
      reportSentryError("IntegrityError", text);
      return true;
    }

    var decoded = json.decode(text);
    var success = decoded['place'] == id;
    if (success && context != null)
      Provider.of<Tracks>(context, listen: false).markAsVisited(id);

    return success;
  }
}

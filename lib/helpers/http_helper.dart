import 'dart:convert';

import 'package:http/http.dart' as http;

const API_MASTER_URL = "https://wroclaw-przystepnie.herokuapp.com/v0";

class HttpHelper {
  static Future<List<Map<String, dynamic>>> fetchPlaces(
      Map<String, String> headers) async {
    var url = "$API_MASTER_URL/places/";
    var response = await http.get(
      url,
      headers: headers,
    );
    return List<Map<String, dynamic>>.from(
        json.decode(utf8.decode(response.bodyBytes)));
  }

  static Future<List<Map<String, dynamic>>> fetchTracks(
      Map<String, String> headers) async {
    var url = "$API_MASTER_URL/paths/";
    var response = await http.get(
      url,
      headers: headers,
    );
    return List<Map<String, dynamic>>.from(
        json.decode(utf8.decode(response.bodyBytes)));
  }
}

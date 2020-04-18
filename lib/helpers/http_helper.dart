import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpHelper {
  static Future<List<Map<String, dynamic>>> fetchPlaces(
      Map<String, String> headers) async {
    var url = "https://wroclaw-przystepnie.herokuapp.com/v0/places/";
    var response = await http.get(
      url,
      headers: headers,
    );
    return List<Map<String, dynamic>>.from(
        json.decode(utf8.decode(response.bodyBytes)));
  }
}

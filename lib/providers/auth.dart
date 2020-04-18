import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class Auth with ChangeNotifier {
  String token;
  String id;

  String phoneNumber;
  String pk;

  String debug;

  int validationErrorCode;

  bool loggingProcess = true;

  Auth() {
    autoLogin();
  }

  Map<String, String> get headers {
    // if (isAuthed)
    if (false)
      return Map<String, String>.from({
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      });
    else
      return Map<String, String>.from({
        "Content-Type": "application/json",
      });
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getStringList("auth");
    if (auth != null) {
      token = auth[0];
      phoneNumber = auth[1];
    }
    loggingProcess = false;
    notifyListeners();
  }

  bool get isAuthed => phoneNumber != null && token != null;

  Future<bool> sendPhoneNumber(String phoneNum, BuildContext context) async {
    var url =
        "https://wroclaw-przystepnie.herokuapp.com/v0/auth/phone/generate/";
    var hash = await SmsAutoFill().getAppSignature;
    // var response = await http.post(
    //   url,
    //   body: hash == null
    //       ? {"phone_number": phoneNum}
    //       : {"phone_number": phoneNum, "hash": hash},
    // );
    // var decoded = json.decode(response.body);
    // if (decoded['reason'] != null) {
    //   if (decoded["reason"] ==
    //       "you can not have more than 10 attempts per day, please try again tomorrow") {
    //     validationErrorCode = 2;
    //     return false;
    //   }
    //   if (decoded['reason']["phone_number"][0] ==
    //       "The phone number entered is not valid.") {
    //     validationErrorCode = 1;
    //     return false;
    //   }
    // }

    //temporary workaround
    var decoded = {"pk": 1, "phone_number": phoneNum, "debug": "111111"};

    pk = decoded['pk'].toString();
    phoneNumber = decoded["phone_number"];
    debug = decoded['debug'];
    return true;
  }

  Future<bool> validatePhoneNumber(String smsCode) async {
    var url =
        "https://wroclaw-przystepnie.herokuapp.com/v0/auth/phone/validate/";
    // var response = await http.post(
    //   url,
    //   headers: {
    //     "Content-type": "application/json",
    //   },
    //   body: '{"pk": $pk, "otp": $smsCode}',
    // );

    // var decoded = json.decode(utf8.decode(response.bodyBytes));
    // if (decoded["reason"] == "OTP doesn't exist") return false;

    //temporary workaround
    var decoded = {"token": "token benc"};

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("auth", [decoded["token"], phoneNumber]);

    token = decoded["token"];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    phoneNumber = null;
    pk = null;
    id = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = null;
    await prefs.clear();
    notifyListeners();
  }
}

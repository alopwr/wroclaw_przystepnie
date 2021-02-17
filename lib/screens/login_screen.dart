import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../helpers/errors_helper.dart';
import '../providers/auth.dart';
import '../widgets/phone_card.dart';
import '../widgets/pin_code_card.dart';

enum LoginMode { phoneNumber, smsCode }

class LoginScreen extends StatefulWidget {
  final randomFocusNode = FocusNode();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginMode _mode = LoginMode.phoneNumber;
  final _phoneNumberController = TextEditingController();
  String _smsCode = "";
  bool acceptRules = false;
  bool acceptRulesError = false;
  bool validating = false;
  String errorMessage;
  var appBar = AppBar(title: const Text("Wrocław Przystępnie"));
  OverlayEntry overlayEntry;

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  bool validatePhoneNumber() {
    var val = _phoneNumberController.value.text;
    if (val.length <= 0) {
      errorMessage = "Numer telefonu nie może być pusty";
      return false;
    }
    return true;
  }

  bool validateSmsCode() {
    return true;
  }

  void setAcceptRules(bool value) {
    setState(() {
      acceptRules = value;
    });
  }

  Future _submitSmsCode() async {
    if (FocusScope.of(context).canRequestFocus)
      FocusScope.of(context).requestFocus(widget.randomFocusNode);
    if (!validateSmsCode()) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    var isValid = await Provider.of<Auth>(context, listen: false)
        .validatePhoneNumber(_smsCode);
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (!isValid) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Niepoprawny kod"),
                content: const Text("Wprowadzony kod sms jest niepoprawny."),
                actions: <Widget>[
                  FlatButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
      setState(() {
        _smsCode = "";
      });
      return;
    }
  }

  void closeEntry() {
    overlayEntry?.remove();
  }

  void _submitPhoneNumber() async {
    if (FocusScope.of(context).canRequestFocus)
      FocusScope.of(context).requestFocus(widget.randomFocusNode);
    if (!validatePhoneNumber()) return;

    if (!acceptRules) {
      setState(() {
        acceptRulesError = true;
      });
      return;
    }

    await SmsAutoFill().listenForCode;
    showPinCode();
    var isValid = await Provider.of<Auth>(context, listen: false)
        .sendPhoneNumber(_phoneNumberController.value.text, context);
    if (!isValid) {
      var errorCode =
          Provider.of<Auth>(context, listen: false).validationErrorCode;
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
                title: Text(ErrorCodeHelper.title(errorCode)),
                content: Text(ErrorCodeHelper.content(errorCode)),
                actions: <Widget>[
                  FlatButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        returnToPhoneInput();
                      })
                ],
              ));
      return;
    }

    var debug = Provider.of<Auth>(context, listen: false).debug;
    if (debug != null && debug != "null") {
      var overlay = Overlay.of(context);
      overlayEntry = OverlayEntry(
          builder: (context) => Positioned(
                top: 50,
                left: 10,
                child: SizedBox(
                  // height: 50,
                  width: MediaQuery.of(context).size.width - 20,
                  child: Card(
                    child: ListTile(
                      dense: true,
                      leading: const Icon(Icons.textsms),
                      title: Text("Twój testowy kod: $debug"),
                      subtitle: const Text("Aby oszczędzać na sms-ach"),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: closeEntry,
                      ),
                    ),
                  ),
                ),
              ));
      overlay.insert(overlayEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final trueHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        height: max(trueHeight, 470),
        width: mediaQuery.size.width,
        child: SingleChildScrollView(
            child: SizedBox(
          height: max(trueHeight, 470),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // const Logo(),
                const SizedBox(height: 1),
                _mode == LoginMode.phoneNumber
                    ? PhoneNumberCard(
                        controller: _phoneNumberController,
                        errorMessage: errorMessage,
                        appBar: appBar,
                        submit: _submitPhoneNumber,
                        accept: acceptRules,
                        setAccept: setAcceptRules,
                        showError: acceptRulesError,
                      )
                    : PinCodeCard(_smsCode, setCode, _submitSmsCode),
              ]),
        )),
      ),
    );
  }

  void showPinCode() {
    setState(() {
      appBar = AppBar(
        leading: FlatButton(
          child: const Icon(Icons.arrow_back),
          onPressed: returnToPhoneInput,
        ),
        title: const Text("Wrocław Przystępnie"),
      );
      _mode = LoginMode.smsCode;
    });
  }

  void returnToPhoneInput() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        fullscreenDialog: true, builder: (_) => LoginScreen()));
  }

  Future setCode(String newVal) async {
    var oldVal = _smsCode;
    _smsCode = newVal;
    if (_smsCode.length == 6 && newVal != oldVal) {
      await _submitSmsCode();
    }
  }
}

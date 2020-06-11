import 'package:flutter/material.dart';

class LocationPermissionInfoPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Wymagane pozwolenie"),
      content: const Text(
          "Potrzebujemy twojego pozwolenia na lokalizację, aby wyświetlać miejsca blisko ciebie oraz zapewnić ci możliwość meldowania na punktach tras."),
      actions: <Widget>[
        FlatButton(
            onPressed: Navigator.of(context).pop, child: const Text("Ok"))
      ],
    );
  }
}

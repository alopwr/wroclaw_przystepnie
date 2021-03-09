import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_location.dart';

class LocationWarningBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var displayWarningIcon =
        Provider.of<UserLocationManager>(context).displayWarningIcon;
    if (displayWarningIcon)
      return FloatingActionButton(
        child: Icon(Icons.location_disabled),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).primaryColorDark,
        mini: true,
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Brak danych lokalizacyjnych"),
                  content: const Text(
                      "Niestety aplikacja nie ma dostępu do twoich danych lokalizacyjnych. Sprawdź, czy usługi lokalizacyjne są włączone, a wszystkie pozwolenia aplikacji przydzielone."),
                  actions: <Widget>[
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                )),
      );
    else
      return Container();
  }
}

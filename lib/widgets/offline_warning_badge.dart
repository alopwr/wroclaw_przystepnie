import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import '../providers/paths.dart';

class OfflineWarningBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Places>(context).offlineBadge ||
        Provider.of<Paths>(context).offlineBadge)
      return FloatingActionButton(
        child: const Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).errorColor,
        mini: true,
        onPressed: () => showDialog(
            context: context,
            child: AlertDialog(
              title: const Text("Błąd odświeżania"),
              content: const Text(
                  "Niestety nie udało się odświeżyć danych z serwera. Wyświetlane są dane historyczne."),
              actions: <Widget>[
                FlatButton(
                  child: const Text("Ok"),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/paths.dart';
import '../providers/places.dart';

class OfflineWarningBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Places>(context).offlineBadge ||
        Provider.of<Paths>(context).offlineBadge)
      return FloatingActionButton(
        child: Icon(
          Icons.error_outline,
          color: Theme.of(context).primaryColor,
        ),
        backgroundColor: Theme.of(context).primaryColorDark,
        mini: true,
        onPressed: () => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text("Błąd odświeżania"),
                  content: const Text(
                      "Niestety nie udało się odświeżyć danych z serwera. Wyświetlane są dane historyczne."),
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

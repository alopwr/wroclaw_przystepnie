import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/locator.dart';
import '../providers/place.dart';
import '../providers/places.dart';
import 'custom_icons.dart';
import 'global_dialogs.dart';

class GoogleMapsToolbar extends StatelessWidget {
  Future showDirections(Place activePlace) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=${activePlace.location.latitude},${activePlace.location.longitude}';
    if (await canLaunch(url))
      await launch(url);
    else
      messageFailure();
  }

  Future showPlace(Place activePlace) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${activePlace.location.latitude},${activePlace.location.longitude}';
    if (await canLaunch(url))
      await launch(url);
    else
      messageFailure();
  }

  void messageFailure() {
    final context =
        locator<GlobalKey<GlobalContextProviderState>>().currentContext;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Niepowodzenie"),
        content: const Text("Nie udało się otworzyć Google Maps"),
        actions: <Widget>[
          TextButton(
            child: const Text("Ok"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var activePlace = Provider.of<Places>(context).activePlace;
    if (activePlace == null) return Container();

    return Card(
      elevation: 6,
      child: Row(
        children: <Widget>[
          IconButton(
            color: Colors.black.withOpacity(0.75),
            icon: const Icon(Icons.directions),
            iconSize: 25,
            onPressed: () => showDirections(activePlace),
          ),
          IconButton(
            color: Colors.black.withOpacity(0.75),
            icon: const Icon(MyCustomIcons.google_maps),
            iconSize: 25,
            onPressed: () => showPlace(activePlace),
          ),
        ],
      ),
    );
  }
}

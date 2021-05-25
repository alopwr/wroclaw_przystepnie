import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../main.dart';
import '../providers/places.dart';
import '../providers/user_location.dart';
import 'custom_icons.dart';

Future<void> farAwayWarning(BuildContext context) async {
  var canVibrate = false;
  if (!kIsWeb) canVibrate = await Vibration.hasVibrator();
  Navigator.of(context).popUntil((route) => route.isFirst);
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Icon(
      MyCustomIcons.map_marker_distance,
      color: Colors.red,
      size: 70,
    ),
  );
  if (canVibrate) {
    Vibration.vibrate();
    await Future.delayed(Duration(milliseconds: 600));
    Vibration.vibrate();
  }
  await Future.delayed(Duration(milliseconds: 600));
  Navigator.of(context).popUntil((route) => route.isFirst);
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Jesteś za daleko"),
            content: const Text(
                "Aby oznaczyć punkt jako odwiedziony, musisz znajdować się w promieniu 50 metrów od punktu"),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
}

Future<void> markAsVisited(
    BuildContext context, int id, LatLng location) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator()),
  );
  try {
    var correctDistance =
        await Provider.of<UserLocationManager>(context, listen: false)
            .placeDistanceValidation(location);

    if (!correctDistance) {
      await farAwayWarning(context);
      return;
    }
    await Provider.of<Places>(context, listen: false)
        .markAsVisited(id, context);

    var canVibrate = false;
    if (!kIsWeb) canVibrate = await Vibration.hasVibrator();
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (canVibrate) Vibration.vibrate();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Icon(
        MyCustomIcons.map_marker_check,
        color: MyApp.green,
        size: 70,
      ),
    );
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.of(context).popUntil((route) => route.isFirst);
  } on PermissionDeniedException {
    bool canVibrate = false;
    if (!kIsWeb) canVibrate = await Vibration.hasVibrator();
    if (canVibrate) Vibration.vibrate();
    Navigator.of(context).popUntil((route) => route.isFirst);

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Błąd pozwoleń lokalizacji"),
              content: Text(
                  "Zezwól na dostęp do lokalizacji, aby potwierdzić obecność na punkcie."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                )
              ],
            ));
  } on LocationServiceDisabledException {
    bool canVibrate = false;
    if (!kIsWeb) canVibrate = await Vibration.hasVibrator();
    if (canVibrate) Vibration.vibrate();
    Navigator.of(context).popUntil((route) => route.isFirst);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Błąd lokalizacji"),
              content: Text(
                  "Włącz usługi lokalizacyjne, aby potwierdzić obecność na punkcie."),
              actions: <Widget>[
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                )
              ],
            ));
  } catch (e) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

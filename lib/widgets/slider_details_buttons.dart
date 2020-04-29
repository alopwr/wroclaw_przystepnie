import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import '../providers/places.dart';
import 'circle_button.dart';
import 'custom_icons.dart';

class SliderDetailsButtons extends StatelessWidget {
  const SliderDetailsButtons();

  @override
  Widget build(BuildContext context) {
    var place = Provider.of<Places>(context).activePlace;
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        CircleButton(
          label: place.isVisited ? "Odwiedzone" : "Oznacz jako\nodwiedzone",
          color: place.isVisited ? Colors.grey : Colors.green,
          icon: Icons.check,
          onPressed:
              place.isVisited ? null : () => markAsVisited(context, place.id),
        ),
        CircleButton(
          label: "Wróć",
          color: Colors.grey,
          icon: Icons.arrow_back_ios,
          onPressed: () {
            Provider.of<Places>(context, listen: false).showMenuAndZoomOut();
          },
        ),
      ],
    );
  }

  Future<void> markAsVisited(BuildContext context, int id) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      child: const Center(child: CircularProgressIndicator()),
    );
    var success = await Provider.of<Places>(context, listen: false)
        .markAsVisited(id, context);

    if (!success) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      showDialog(
          context: context,
          child: AlertDialog(
            title: const Text("Niepowodzenie"),
            content: const Text(
                "Niestety nie udało się oznanaczyć miejsc jako odwiedzione"),
            actions: <Widget>[
              FlatButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ));
      return;
    }
    var canVibrate = false;
    if (!kIsWeb) canVibrate = await Vibration.hasVibrator();
    Navigator.of(context).popUntil((route) => route.isFirst);
    if (canVibrate) Vibration.vibrate();
    showDialog(
      context: context,
      barrierDismissible: false,
      child: const Icon(
        MyCustomIcons.map_marker_check,
        color: Colors.green,
        size: 70,
      ),
    );
    await Future.delayed(Duration(milliseconds: 500));
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}

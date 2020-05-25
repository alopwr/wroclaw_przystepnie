import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'check_in_helper.dart';
import 'circle_button.dart';

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
          label: place.isVisited
              ? "Odwiedzone"
              : place.wrongOrder
                  ? "Odwiedź najpierw\npoprzednie punkty"
                  : "Oznacz jako\nodwiedzone",
          color:
              place.isVisited || place.wrongOrder ? Colors.grey : Colors.green,
          icon: Icons.check,
          onPressed: place.isVisited || place.wrongOrder
              ? null
              : () => markAsVisited(context, place.id, place.location),
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
}

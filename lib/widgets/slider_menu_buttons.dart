import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../providers/auth.dart';
import '../providers/places.dart';
import 'circle_button.dart';
import 'custom_icons.dart';
import 'placeholder_button.dart';

class SliderMenuButtons extends StatelessWidget {
  const SliderMenuButtons();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        PlaceholderButton(
          MyApp.green,
        ),
        PlaceholderButton(
          Theme.of(context).primaryColor,
        ),
        CircleButton(
          label: "Losuj",
          icon: MyCustomIcons.dice_3,
          color: Theme.of(context).primaryColorDark,
          onPressed: Provider.of<Places>(context, listen: false).detailRandom,
        ),
        CircleButton(
          label: "Wyloguj się",
          icon: Icons.exit_to_app,
          color: Colors.grey,
          onPressed: Provider.of<Auth>(context, listen: false).logout,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'dash.dart';
import 'slider_details_body.dart';
import 'slider_details_buttons.dart';
import 'slider_menu_body.dart';
import 'slider_menu_buttons.dart';
import 'slider_track_body.dart';
import 'slider_track_button.dart';

enum MenuType { menu, track, placeDetail }

class SliderPanel extends StatelessWidget {
  SliderPanel(this.scrollController);

  final ScrollController scrollController;
  MenuType type;

  String title(Places places) {
    if (type == MenuType.menu)
      return "Zwiedzaj Wrocław!";
    else if (type == MenuType.track)
      return places.currentTrack.name;
    else
      return places.activePlace.name;
  }

  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    places.scrollController = scrollController;
    if (places.activePlace != null)
      type = MenuType.placeDetail;
    else if (places.currentTrack != null)
      type = MenuType.track;
    else
      type = MenuType.menu;

    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            const Dash(),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title(places),
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Container(
              child: type == MenuType.menu
                  ? const SliderMenuButtons()
                  : type == MenuType.track
                      ? const SliderTrackButtons()
                      : const SliderDetailsButtons(),
            ),
            const SizedBox(height: 36),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: type == MenuType.menu
                    ? const SliderMenuBody()
                    : type == MenuType.track
                        ? SliderTrackBody(places.currentTrack.description)
                        : const SliderDetailsBody(),
              ),
            ),
          ],
        ));
  }
}

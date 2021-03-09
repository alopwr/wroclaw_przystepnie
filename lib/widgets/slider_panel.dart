import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'dash.dart';
import 'slider_details_body.dart';
import 'slider_details_buttons.dart';
import 'slider_menu_body.dart';
import 'slider_menu_buttons.dart';
import 'slider_path_body.dart';
import 'slider_path_button.dart';

enum MenuType { menu, path, placeDetail }

class SliderPanel extends StatelessWidget {
  SliderPanel(this.scrollController);

  final ScrollController scrollController;
  MenuType type;

  String title(Places places) {
    if (type == MenuType.menu)
      return "Zwiedzaj Wrocław!";
    else if (type == MenuType.path)
      return places.currentPath.name;
    else
      return places.activePlace.name;
  }

  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    places.scrollController = scrollController;
    if (places.activePlace != null)
      type = MenuType.placeDetail;
    else if (places.currentPath != null)
      type = MenuType.path;
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title(places),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Container(
            child: type == MenuType.menu
                ? const SliderMenuButtons()
                : type == MenuType.path
                    ? const SliderPathButtons()
                    : const SliderDetailsButtons(),
          ),
          const SizedBox(height: 36),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: !Provider.of<Places>(context, listen: false)
                      .panelController
                      .isPanelOpen
                  ? const NeverScrollableScrollPhysics()
                  : null,
              child: type == MenuType.menu
                  ? const SliderMenuBody()
                  : type == MenuType.path
                      ? SliderPathBody(places.currentPath.description)
                      : const SliderDetailsBody(),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'slider_details.dart';
import 'slider_menu.dart';

class SliderPanel extends StatelessWidget {
  SliderPanel(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    var activePlace = places.activePlace;
    if (activePlace == null) return SliderMenu(scrollController);
    return SliderDetails(scrollController, activePlace);
  }
}

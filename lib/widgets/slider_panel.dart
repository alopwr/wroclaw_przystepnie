import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'slider_details.dart';
import 'slider_menu.dart';
import 'slider_track.dart';

class SliderPanel extends StatelessWidget {
  SliderPanel(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    places.panelScrollController = scrollController;
    var activePlace = places.activePlace;
    if (activePlace != null)
      return SliderDetails(scrollController, activePlace);
    if (places.currentTrack != null) return SliderTrackMenu(scrollController);
    return SliderMenu(scrollController);
  }
}

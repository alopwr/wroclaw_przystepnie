import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';

import 'places_on_path_list.dart';
import 'sticky_section.dart';

class SliderPathBody extends StatelessWidget {
  SliderPathBody(this.description);
  final String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          StickySection(
            title: "Opis:",
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ExpandText(description),
              ),
            ),
          ),
          const SizedBox(height: 18),
          StickySection(
            title: "Punkty:",
            child: Align(
              alignment: Alignment.topLeft,
              child: PlacesOnPathList(),
            ),
          ),
        ],
      ),
    );
  }
}

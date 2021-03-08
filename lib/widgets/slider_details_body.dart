import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'audio_widget.dart';
import 'photo_gallery.dart';
import 'sticky_section.dart';

class SliderDetailsBody extends StatelessWidget {
  const SliderDetailsBody();
  @override
  Widget build(BuildContext context) {
    var place = Provider.of<Places>(context).activePlace;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (place.description.length > 0)
            StickySection(
              title: "Opis:",
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ExpandText(place.description),
                ),
              ),
            ),
          if (place.mediaGallerySet.length > 0)
            StickySection(
              title: "Multimedia:",
              child: PhotoGallery(place),
            ),
          if (place.audioSet.length > 0)
            StickySection(
                title: "Audio:",
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: place.audioSet
                          .map((audio) => AudioWidget(audio))
                          .toList()),
                )),
        ],
      ),
    );
  }
}

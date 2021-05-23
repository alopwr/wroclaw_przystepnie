import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'audio_widget.dart';
import 'expander.dart';
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
                  child: Expander(body: place.description),
                ),
              ),
            ),
          if (place.mediaGallerySet.length > 0) PhotoGallery(place),
          // StickySection(
          //   title: "Multimedia:",
          //   child: ,
          // ),
          const SizedBox(height: 10),

          const SizedBox(height: 10),

          if (place.audioSet.length > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...place.audioSet,
                    ...place.audioSet,
                    ...place.audioSet
                  ].map((audio) => AudioWidget(audio)).toList()),
            ),
          // StickySection(
          //     title: "Audio:",
          //     child: ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

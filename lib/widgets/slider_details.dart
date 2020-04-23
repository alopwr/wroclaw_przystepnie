import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/place.dart';
import '../providers/places.dart';
import 'audio_widget.dart';
import 'circle_button.dart';
import 'dash.dart';
import 'photo_gallery.dart';
import 'sticky_section.dart';

class SliderDetails extends StatelessWidget {
  SliderDetails(this.scrollController, this.place);

  final ScrollController scrollController;
  final Place place;

  @override
  Widget build(BuildContext context) {
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
                place.name,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleButton(
                label: "Oznacz jako\nodwiedzone",
                color: Colors.green,
                icon: Icons.check,
                onPressed: () {},
              ),
              CircleButton(
                label: "Wróć",
                color: Colors.grey,
                icon: Icons.arrow_back_ios,
                onPressed: () {
                  Provider.of<Places>(context, listen: false)
                      .showMenuAndZoomOut();
                },
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                  StickySection(
                    title: "Multimedia:",
                    child: PhotoGallery(place),
                  ),
                  StickySection(
                      title: "Audio",
                      child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shrinkWrap: true,
                          children: place.audioSet
                              .map((audio) => AudioWidget(audio))
                              .toList())),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

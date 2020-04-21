import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:wroclaw_przystepnie/widgets/progress_bar.dart';

import '../providers/places.dart';
import 'circle_button.dart';
import 'dash.dart';
import 'places_on_track_list.dart';

class SliderTrackMenu extends StatelessWidget {
  SliderTrackMenu(this.scrollController);
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    var track = Provider.of<Places>(context).currentTrack;
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 12),
          const Dash(),
          const SizedBox(height: 18),
          FittedBox(
            child: Text(
              track.name,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 24.0,
              ),
            ),
          ),
          const SizedBox(height: 36),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 35),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text("Twój postęp:",
                            style: Theme.of(context)
                                .textTheme
                                .body2
                                .copyWith(fontWeight: FontWeight.bold))),
                    Padding(
                      padding: const EdgeInsets.only(left: 11, top: 8),
                      child: ProgressBar(track),
                    ),
                  ],
                )),
                const SizedBox(width: 40),
                CircleButton(
                  label: "",
                  icon: Icons.close,
                  color: Colors.grey,
                  onPressed: () {
                    Provider.of<Places>(context, listen: false)
                        .clearFilter(close: true, zoomOut: true);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  StickyHeader(
                    header: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: Text("Opis:",
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                    content: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ExpandText(track.description),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  StickyHeader(
                    header: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: Text("Punkty:",
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                    content: Align(
                      alignment: Alignment.topLeft,
                      child: PlacesOnTrackList(),
                    ),
                  ),
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

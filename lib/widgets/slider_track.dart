import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: <Widget>[
                Expanded(child: ProgressBar(track)),
                const SizedBox(width: 50),
                CircleButton(
                  label: "",
                  icon: Icons.close,
                  color: Colors.grey,
                  onPressed: () {
                    Provider.of<Places>(context, listen: false)
                        .clearFilter(close: true);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Flexible(
          //   child: SingleChildScrollView(
          //     controller: scrollController,
          //     child:
          //   ),
          // ),
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text("Opis:",
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: ExpandText(track.description),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text("Punkty:", 
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  PlacesOnTrackList(),
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

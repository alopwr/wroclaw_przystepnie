import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/track.dart';
import '../providers/tracks.dart';
import '../providers/places.dart';
import 'progress_bar.dart';

class TracksPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tracks = Provider.of<Tracks>(context).tracks;
    var places = Provider.of<Places>(context);
    var currentTrack = places.currentTrack;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: tracks
          .map(
            (track) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: currentTrack == track ? Colors.blueGrey.shade50 : null,
                child: ListTile(
                  title: Text(
                    track.name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: currentTrack == track
                      ? Icon(Icons.close,
                          size: 28, color: Theme.of(context).errorColor)
                      : Transform.rotate(
                          angle: pi / 4,
                          child: const Icon(Icons.navigation, size: 28)),
                  subtitle: ProgressBar(track),
                  onTap: currentTrack == track
                      ? places.clearFilter
                      : () => Provider.of<Places>(context, listen: false)
                          .setVisiblePlacesFilter(track),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wroclaw_przystepnie/providers/tracks.dart';

import '../providers/places.dart';

class TracksPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tracks = Provider.of<Tracks>(context,listen: false).tracks;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: tracks
            .map(
              (track) => Card(
                child: ListTile(
                  leading: const Icon(Icons.map),
                  title: Text(track.name),
                  subtitle:
                      track.description != "" ? Text(track.description) : null,
                  onTap: () {
                    Provider.of<Places>(context, listen: false)
                        .setVisiblePlacesFilter(track.places);
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

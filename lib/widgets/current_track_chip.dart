import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';

class CurrentTrackChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    var currentTrack = places.currentTrack;

    if (currentTrack == null)
      return Container();
    else
      return Chip(
        backgroundColor: Colors.white,
        label: Text("Trasa: ${currentTrack.name}"),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          places.clearFilter();
        },
      );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';

class CurrentPathChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    var currentPath = places.currentPath;

    if (currentPath == null)
      return Container();
    else
      return Chip(
        backgroundColor: Colors.white,
        label: Text("Trasa: ${currentPath.name}"),
        deleteIcon: const Icon(Icons.close, size: 18),
        onDeleted: () {
          places.clearFilter();
        },
      );
  }
}

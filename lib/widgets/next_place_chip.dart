import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';

class NextPlaceChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    var currentPath = places.currentPath;

    if (currentPath == null || !currentPath.enforceOrder)
      return Container();
    else {
      var nextPoint = currentPath.nextPoint;
      if (nextPoint == null)
        return Container();
      else
        return GestureDetector(
          onTap: () => places.showDetails(nextPoint.id),
          child: Chip(
            backgroundColor: Colors.white,
            label: Text("${nextPoint.name}"),
            deleteIcon: const Icon(Icons.arrow_forward, size: 18),
            onDeleted: () {
              places.showDetails(nextPoint.id);
            },
          ),
        );
    }
  }
}

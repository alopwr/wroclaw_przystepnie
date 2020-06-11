import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';

class PreviousPlaceChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    var currentPath = places.currentPath;

    if (currentPath == null || !currentPath.enforceOrder)
      return Container();
    else {
      var previousPoint = currentPath.previousPoint;
      if (previousPoint == null)
        return Container();
      else
        return GestureDetector(
          onTap: () => places.showDetails(previousPoint.id),
          child: Chip(
            backgroundColor: Colors.white,
            label: Text("${previousPoint.name}"),
            avatar: const Icon(Icons.arrow_back, size: 18),
          ),
        );
    }
  }
}

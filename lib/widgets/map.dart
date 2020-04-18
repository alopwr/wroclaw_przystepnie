import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wroclaw_przystepnie/providers/places.dart';

class MapWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);

    return GestureDetector(
      child: Center(
        child: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.yellow,
            child: const Text(
                "map widget placeholder\ntap to show example detail view\ndouble tap to hide")),
      ),
      onTap: () => places.showDetails(1),
      onDoubleTap: () => places.hideDetails(),
    );
  }
}

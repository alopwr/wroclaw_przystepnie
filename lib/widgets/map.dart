import 'package:flutter/material.dart';

class MapWidget extends StatelessWidget {
  MapWidget(this.showF, this.hideF);

  final Function showF;
  final Function hideF;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
            color: Colors.yellow,
            child: const Text("map widget placeholder\ntap to show example detail view\ndouble tap to hide")),
      ),
      onTap: showF,
      onDoubleTap: hideF,
    );
  }
}

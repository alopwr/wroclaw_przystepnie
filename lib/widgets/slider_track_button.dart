import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'progress_bar.dart';
import 'circle_button.dart';

class SliderTrackButtons extends StatelessWidget {
  const SliderTrackButtons();
  @override
  Widget build(BuildContext context) {
    var track = Provider.of<Places>(context).currentTrack;
    return Padding(
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
    );
  }
}

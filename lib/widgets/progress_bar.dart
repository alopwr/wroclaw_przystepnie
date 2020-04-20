import 'package:flutter/material.dart';

import '../providers/track.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar(this.track);

  final Track track;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: LinearProgressIndicator(value: .8)),
        const SizedBox(width: 20),
        Text("80%", style: Theme.of(context).textTheme.bodyText2)
      ],
    );
  }
}

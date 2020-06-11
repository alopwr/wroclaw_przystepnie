import 'package:flutter/material.dart';

import '../providers/path.dart';

class ProgressBar extends StatelessWidget {
  ProgressBar(this.path);
  final Path path;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: LinearProgressIndicator(value: path.progress)),
        const SizedBox(width: 20),
        Text(path.progressLabel, style: Theme.of(context).textTheme.bodyText2)
      ],
    );
  }
}

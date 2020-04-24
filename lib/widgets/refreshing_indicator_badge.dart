import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';

class RefreshIndicatorBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Places>(context).refreshingBadge ?? true)
      return FloatingActionButton(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              width: 15,
              height: 15,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        mini: true,
        onPressed: () {},
      );
    else
      return Container();
  }
}

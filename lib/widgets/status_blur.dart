import 'dart:ui';

import 'package:flutter/material.dart';

class StatusBlur extends StatelessWidget {
  const StatusBlur({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).padding.top,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

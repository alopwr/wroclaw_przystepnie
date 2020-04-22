import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class StickySection extends StatelessWidget {
  StickySection({this.title, this.child});

  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Text(title,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontWeight: FontWeight.w600)),
      ),
      content: child,
    );
  }
}

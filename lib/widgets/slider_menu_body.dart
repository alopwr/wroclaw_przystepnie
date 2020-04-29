import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tracks.dart';
import 'sticky_section.dart';
import 'tracks_picker.dart';

class SliderMenuBody extends StatelessWidget {
  const SliderMenuBody();
  @override
  Widget build(BuildContext context) {
    return StickySection(
      title: "Trasy: ",
      child: FutureBuilder(
        future: Provider.of<Tracks>(context, listen: false).getTracks(),
        initialData: Provider.of<Tracks>(context, listen: false).tracks,
        builder: (context, snapshot) {
          if (snapshot.data == null &&
              snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasError) return TracksPicker();

          return Center(
              child: Text(
            "Oops! Coś poszło nie tak",
            style: TextStyle(color: Theme.of(context).errorColor),
          ));
        },
      ),
    );
  }
}

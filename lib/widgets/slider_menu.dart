import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wroclaw_przystepnie/providers/tracks.dart';

import '../providers/auth.dart';
import '../providers/places.dart';
import 'circle_button.dart';
import 'custom_icons.dart';
import 'dash.dart';
import 'placeholder_button.dart';
import 'tracks_picker.dart';

class SliderMenu extends StatelessWidget {
  SliderMenu(this.scrollController);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            const Dash(),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Zwiedzaj Wrocław",
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                PlaceholderButton(
                  Colors.blue,
                ),
                PlaceholderButton(
                  Colors.green,
                ),
                CircleButton(
                  label: "Losuj",
                  icon: MyCustomIcons.dice_3,
                  color: Colors.red,
                  onPressed:
                      Provider.of<Places>(context, listen: false).detailRandom,
                ),
                CircleButton(
                  label: "Wyloguj się",
                  icon: Icons.exit_to_app,
                  color: Colors.grey,
                  onPressed: Provider.of<Auth>(context, listen: false).logout,
                ),
              ],
            ),
            const SizedBox(height: 36),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text("Trasy:",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: FutureBuilder(
                  future:
                      Provider.of<Tracks>(context, listen: false).getTracks(),
                  initialData:
                      Provider.of<Tracks>(context, listen: false).tracks,
                  builder: (context, snapshot) {
                    if (snapshot.data == null &&
                        snapshot.connectionState == ConnectionState.waiting)
                      return const Center(child: CircularProgressIndicator());
                    else if (!snapshot.hasError) return TracksPicker();
                    print(snapshot.error);
                    return Center(
                        child: Text(
                      "Oops! Coś poszło nie tak",
                      style: TextStyle(color: Theme.of(context).errorColor),
                    ));
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ));
  }
}

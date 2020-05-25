import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'custom_icons.dart';

class PlacesOnTrackList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    return Column(
      children: places.visiblePlaces
          .map(
            (place) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: place.wrongOrder ? Colors.grey.shade300 : null,
                child: ListTile(
                  title: Text(
                    place.name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    place.isVisited
                        ? MyCustomIcons.map_marker_check
                        : Icons.place,
                    size: 28,
                    color: place.isVisited
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                  ),
                  onTap: () => places.showDetails(place.id),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

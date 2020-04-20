import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wroclaw_przystepnie/providers/places.dart';

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
                child: ListTile(
                  title: Text(
                    place.name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(
                    Icons.place,
                    size: 28,
                    color: Theme.of(context).primaryColor,
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

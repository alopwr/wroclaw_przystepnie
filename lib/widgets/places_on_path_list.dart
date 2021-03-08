import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';
import 'custom_icons.dart';

class PlacesOnPathList extends StatelessWidget {
  const PlacesOnPathList();
  @override
  Widget build(BuildContext context) {
    var places = Provider.of<Places>(context);
    return Column(
      children: places.visiblePlaces
          .map(
            (place) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: place.wrongOrder ? Colors.grey.shade300 : Colors.white,
                  boxShadow: [
                    if (!place.wrongOrder)
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(2, 2),
                        blurRadius: 8,
                      ),
                  ],
                ),
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

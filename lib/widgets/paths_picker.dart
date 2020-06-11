import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/paths.dart';
import '../providers/places.dart';
import 'progress_bar.dart';

class PathsPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var paths = Provider.of<Paths>(context).paths;
    var places = Provider.of<Places>(context);
    var currentPath = places.currentPath;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: paths
          .map(
            (path) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                color: currentPath == path ? Colors.blueGrey.shade50 : null,
                child: ListTile(
                  title: Text(
                    path.name,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  trailing: currentPath == path
                      ? Icon(Icons.close,
                          size: 28, color: Theme.of(context).errorColor)
                      : const Icon(Icons.near_me, size: 28),
                  subtitle: ProgressBar(path),
                  onTap: currentPath == path
                      ? places.clearFilter
                      : () => Provider.of<Places>(context, listen: false)
                          .setVisiblePlacesFilter(path),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

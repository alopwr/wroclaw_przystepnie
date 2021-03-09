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

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: paths
            .map(
              (path) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: currentPath == path
                        ? Colors.blueGrey.shade50
                        : Colors.white,
                    boxShadow: [
                      if (currentPath != path)
                        BoxShadow(
                          color: const Color(0x29000000),
                          offset: Offset(0, 3),
                          blurRadius: 8,
                        ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: ListTile(
                      title: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          path.name,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: currentPath == path
                          ? Icon(Icons.close,
                              size: 28, color: Theme.of(context).errorColor)
                          : Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: const Icon(
                                Icons.near_me,
                                size: 28,
                              ),
                            ),
                      subtitle: ProgressBar(path),
                      onTap: currentPath == path
                          ? places.clearFilter
                          : () => Provider.of<Places>(context, listen: false)
                              .setVisiblePlacesFilter(path),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

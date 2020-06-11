import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/paths.dart';
import 'sticky_section.dart';
import 'paths_picker.dart';

class SliderMenuBody extends StatelessWidget {
  const SliderMenuBody();
  @override
  Widget build(BuildContext context) {
    return StickySection(
      title: "Trasy: ",
      child: FutureBuilder(
        future: Provider.of<Paths>(context, listen: false).getPaths(),
        initialData: Provider.of<Paths>(context, listen: false).paths,
        builder: (context, snapshot) {
          if (snapshot.data == null &&
              snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasError) return PathsPicker();

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

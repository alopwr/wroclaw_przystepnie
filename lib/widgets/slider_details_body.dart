import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../providers/places.dart';

class SliderDetailsBody extends StatelessWidget {
  const SliderDetailsBody();
  @override
  Widget build(BuildContext context) {
    var place = Provider.of<Places>(context).activePlace;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: MarkdownBody(
                data: place.description,
                styleSheet: MarkdownStyleSheet(
                  textScaleFactor: 1.2,
                ),
                imageBuilder: (uri, title, alt) {
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Image.network(uri.toString()),
                  );
                },
              ),
            ),
          ),
          // if (place.mediaGallerySet.length > 0) PhotoGallery(place),
          // const SizedBox(height: 10),
          // const SizedBox(height: 10),

          // if (place.audioSet.length > 0)
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 24),
          //     child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           ...place.audioSet,
          //           ...place.audioSet,
          //           ...place.audioSet
          //         ].map((audio) => AudioWidget(audio)).toList()),
          //   ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

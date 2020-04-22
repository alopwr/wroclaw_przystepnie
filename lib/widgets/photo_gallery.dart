import 'package:flutter/material.dart';
import 'package:wroclaw_przystepnie/widgets/fullscreen_gallery.dart';
import 'package:wroclaw_przystepnie/widgets/photo_gallery_item.dart';

import '../providers/place.dart';

class PhotoGallery extends StatelessWidget {
  PhotoGallery(this.place);
  final Place place;

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      maxCrossAxisExtent: 250,
      childAspectRatio: 16 / 9,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      children: <Widget>[
        for (var indx = 0; indx < place.mediaSet.length; indx++)
          PhotoGalleryItem(
            media: place.mediaSet[indx],
            onTap: () {
              open(context, indx);
            },
          ),
      ],
    );
  }

  void open(BuildContext context, final int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenGalleryWrapper(
          mediaSet: place.mediaSet,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          initialIndex: index,
        ),
      ),
    );
  }
}

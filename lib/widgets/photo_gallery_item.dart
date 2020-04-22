import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../providers/place.dart';

class PhotoGalleryItem extends StatelessWidget {
  const PhotoGalleryItem({Key key, this.media, this.onTap}) : super(key: key);

  final GestureTapCallback onTap;
  final Media media;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: media.heroTag,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Stack(
            children: <Widget>[
              if (media.isImage) const Center(child: Padding(
                padding: const EdgeInsets.all(50),
                child: Icon(Icons.photo_camera),
              )),
              if (!media.isImage)
                const Center(child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Icon(Icons.play_circle_filled),
                )),
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: media.url,
                // fit: BoxFit.cover,
              )
            ],
          ),
        ),
      ),
    );
  }
}

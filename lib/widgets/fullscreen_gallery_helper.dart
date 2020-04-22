import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../providers/place.dart';

class GalleryBuilderHelper {
  static Widget buildLoading(context, event) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            if (event != null)
              Text(
                "${(100 * (event.cumulativeBytesLoaded / event.expectedTotalBytes)).floor()}%",
                style: const TextStyle(color: Colors.white),
              )
          ],
        ),
      );

  static PhotoViewGalleryPageOptions buildPhotoViewGalleryPageOptions(
          BuildContext context, Media media) =>
      !media.isImage
          ? PhotoViewGalleryPageOptions.customChild(
              child: const SizedBox(
                height: 100,
                width: 100,
                child:
                    const Icon(Icons.play_circle_outline, color: Colors.white),
              ),
              childSize: const Size(100, 100),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              // minScale: PhotoViewComputedScale.contained * 0.5,
              maxScale: PhotoViewComputedScale.covered * 1.4,
              // heroAttributes: PhotoViewHeroAttributes(tag: media.heroTag),
            )
          : PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(media.url),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              // minScale: PhotoViewComputedScale.contained * 0.5,
              maxScale: PhotoViewComputedScale.covered * 1.4,
              heroAttributes: PhotoViewHeroAttributes(tag: media.heroTag),
            );
}

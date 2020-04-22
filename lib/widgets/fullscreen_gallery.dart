import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../providers/place.dart';
import 'fullscreen_gallery_helper.dart';

class FullscreenGalleryWrapper extends StatefulWidget {
  FullscreenGalleryWrapper({
    this.backgroundDecoration,
    this.initialIndex,
    @required this.mediaSet,
  }) : pageController = PageController(initialPage: initialIndex);

  final Decoration backgroundDecoration;
  final int initialIndex;
  final PageController pageController;
  final List<Media> mediaSet;

  @override
  State<StatefulWidget> createState() {
    return _FullscreenGalleryWrapperState();
  }
}

class _FullscreenGalleryWrapperState extends State<FullscreenGalleryWrapper> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (context, index) =>
                  GalleryBuilderHelper.buildPhotoViewGalleryPageOptions(
                      context, widget.mediaSet[index]),
              itemCount: widget.mediaSet.length,
              loadingBuilder: GalleryBuilderHelper.buildLoading,
              backgroundDecoration: widget.backgroundDecoration,
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                widget.mediaSet[currentIndex].name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

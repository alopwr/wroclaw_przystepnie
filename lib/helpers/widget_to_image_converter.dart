import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

var capturingKey = GlobalKey();

class WidgetToImageConverter {
  static const tickedMarkerIconBase64 =
      "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";

  static BitmapDescriptor get tickedMarkerIcon {
    return BitmapDescriptor.fromBytes(base64Decode(tickedMarkerIconBase64));
  }

  // static Future<Uint8List> captureWidget() async {
  //   try {
  //     print('inside');
  //     RenderRepaintBoundary boundary =
  //         capturingKey.currentContext.findRenderObject();
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     var pngBytes = byteData.buffer.asUint8List();
  //     var bs64 = base64Encode(pngBytes);
  //     print(pngBytes);
  //     print(bs64);
  //     return pngBytes;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
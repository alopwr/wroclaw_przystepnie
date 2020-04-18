import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../widgets/detail_view.dart';
import '../widgets/map.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _initFabHeight = 120.0;
  final appBar = AppBar(
    title: const Text("Wrocław Przystępnie"),
  );

  final panelController = PanelController();

  double _fabHeight = 20;
  double _panelHeightOpen;
  double _panelHeightClosed = 0;
  double _normalPanelHeightClosed = 95.0;

  void showDetail() {
    if (_panelHeightClosed == 0)
      setState(() {
        _panelHeightClosed = _normalPanelHeightClosed;
      });
    else
      panelController.show();
  }

  hideDetail() {
    if (_panelHeightClosed != 0) panelController.hide();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final trueHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    _panelHeightOpen = trueHeight - 10;
    return Scaffold(
      appBar: appBar,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            controller: panelController,
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            snapPoint: .7,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: MapWidget(showDetail, hideDetail),
            panelBuilder: (sc) => DetailView(sc),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.0),
                topRight: Radius.circular(18.0)),
            onPanelSlide: (double pos) => setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _initFabHeight;
            }),
          ),

          // the fab
          Positioned(
            right: 20.0,
            bottom: _fabHeight,
            child: FloatingActionButton(
              child: const Icon(
                Icons.gps_fixed,
                color: Colors.blue,
              ),
              onPressed: () {},
              backgroundColor: Colors.white,
            ),
          ),

          //the SlidingUpPanel Title
          // Positioned(
          //   top: 52.0,
          //   child: Container(
          //     padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 18.0),
          //     child: Text(
          //       "SlidingUpPanel Example",
          //       style: TextStyle(fontWeight: FontWeight.w500),
          //     ),
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(24.0),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 16.0)
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../providers/places.dart';
import '../widgets/detail_view.dart';
import '../widgets/drawer.dart';
import '../widgets/map.dart';

final appBar = AppBar(title: const Text("Wrocław Przystępnie"));

class MapScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: MyDrawer(),
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).fetchPlaces(),
        builder: (context, dataSnapshot) => Stack(
          children: <Widget>[
            MapScreen(mapScreenKey),
            if (dataSnapshot.connectionState == ConnectionState.waiting)
              ModalBarrier(
                color: Colors.black38,
                dismissible: false,
              ),
            if (dataSnapshot.connectionState == ConnectionState.waiting)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    const Text("Pobieranie danych...")
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  MapScreen(key) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  double _fabHeight;
  final _collapsedPanelSituationFabHeight = 120.0;
  final _hiddenPanelSituationFabHeight = 20.0;

  final panelController = PanelController();

  double _panelHeightOpen;
  double _panelHeightClosed = 0;
  final double _normalPanelHeightClosed = 95.0;

  bool isPanelHiding = true;

  @override
  void initState() {
    super.initState();
    _fabHeight = _hiddenPanelSituationFabHeight;
  }

  void showPanel() {
    isPanelHiding = false;
    if (_panelHeightClosed == 0)
      setState(() {
        _panelHeightClosed = _normalPanelHeightClosed;
      });
    else
      panelController.show();
    setState(() {
      _fabHeight = _collapsedPanelSituationFabHeight;
    });
  }

  void hidePanel() {
    isPanelHiding = true;
    if (_panelHeightClosed != 0) panelController.hide();
    setState(() {
      _fabHeight = _hiddenPanelSituationFabHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final trueHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    _panelHeightOpen = trueHeight - 10;

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        SlidingUpPanel(
          controller: panelController,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          snapPoint: .7,
          parallaxEnabled: true,
          parallaxOffset: .5,
          body: MapWidget(),
          panelBuilder: (sc) => DetailView(sc),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          onPanelSlide: (double pos) => setState(() {
            if (!isPanelHiding)
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _collapsedPanelSituationFabHeight;
          }),
        ),
        // the fab
        // Positioned(
        //   right: 20.0,
        //   bottom: _fabHeight,
        //   child: FloatingActionButton(
        //     child: const Icon(
        //       Icons.gps_fixed,
        //       color: Colors.blue,
        //     ),
        //     onPressed: () {},
        //     backgroundColor: Colors.white,
        //   ),
        // ),

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
    );
  }
}

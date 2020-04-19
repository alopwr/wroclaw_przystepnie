import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../providers/places.dart';
import '../widgets/map.dart';
import '../widgets/slider_panel.dart';

class MapScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).fetchPlaces(),
        builder: (context, dataSnapshot) => Stack(
          children: <Widget>[
            MapScreen(),
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
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  double _fabHeight = 120;
  final _collapsedPanelSituationFabHeight = 120.0;

  double _panelHeightOpen;
  double _panelHeightClosed = 95.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<Places>(context, listen: false)
            .panelController
            .animatePanelToSnapPoint());
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _panelHeightOpen = mediaQuery.size.height;

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        SlidingUpPanel(
          controller:
              Provider.of<Places>(context, listen: false).panelController,
          maxHeight: _panelHeightOpen,
          minHeight: _panelHeightClosed,
          collapsed: GestureDetector(
            onTap: Provider.of<Places>(context, listen: false)
                .panelController
                .animatePanelToSnapPoint,
          ),
          snapPoint: .7,
          parallaxEnabled: true,
          parallaxOffset: .5,
          body: MapWidget(),
          panelBuilder: (sc) => SliderPanel(sc),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
          onPanelSlide: (double pos) => setState(() {
            _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                _collapsedPanelSituationFabHeight;
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
    );
  }
}

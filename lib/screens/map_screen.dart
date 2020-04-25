import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../providers/places.dart';
import '../widgets/current_track_chip.dart';
import '../widgets/location_warning_badge.dart';
import '../widgets/map.dart';
import '../widgets/refreshing_indicator_badge.dart';
import '../widgets/offline_warning_badge.dart';
import '../widgets/slider_panel.dart';
import '../widgets/status_blur.dart';
import '../widgets/user_location_button.dart';

class MapScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<Places>(context, listen: false).cachedPlaces(),
        builder: (context, dataSnapshot) => Stack(
          children: <Widget>[
            MapScreen(),
            if (dataSnapshot.connectionState == ConnectionState.waiting ||
                dataSnapshot.hasError)
              ModalBarrier(
                color: Colors.black45,
                dismissible: false,
              ),
            if (dataSnapshot.connectionState == ConnectionState.waiting)
              const Center(
                child: const CircularProgressIndicator(),
              ),
            if (dataSnapshot.hasError)
              Center(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(35),
                  child: FittedBox(
                    child: Text(
                      "Wystąpił błąd pobierania danych z serwera.\nSpróbuj ponownie",
                      softWrap: true,
                      style: TextStyle(
                          color: Theme.of(context).errorColor, fontSize: 40),
                    ),
                  ),
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

  double _trackBadgeTop = 30.0;
  final _collapsedPanelSituationTrackBadgeTop = 30;

  double corner = 18;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        Provider.of<Places>(context, listen: false)
            .panelController
            .animatePanelToSnapPoint());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    _panelHeightOpen = mediaQuery.size.height - mediaQuery.padding.top;

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
          body: Stack(
            children: <Widget>[
              MapWidget(),
              Positioned(
                  top: _trackBadgeTop, left: 10, child: CurrentTrackChip()),
            ],
          ),
          panelBuilder: (sc) => SliderPanel(sc),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(corner),
              topRight: Radius.circular(corner)),
          onPanelSlide: (double pos) {
            setState(() {
              _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  _collapsedPanelSituationFabHeight;
              _trackBadgeTop =
                  .5 * pos * (_panelHeightOpen - _panelHeightClosed) +
                      _collapsedPanelSituationTrackBadgeTop;
              if (pos < 1)
                corner = 18;
              else
                corner = 0;
            });
          },
        ),
        Positioned(
          top: 0,
          child: StatusBlur(),
        ),
        Positioned(
          right: 24.5,
          bottom: _fabHeight,
          child: UserLocationButton(),
        ),
        Positioned(
          top: 30,
          right: 5,
          child: LocationWarningBadge(),
        ),
        Positioned(
          top: 30,
          right: 5,
          child: RefreshIndicatorBadge(),
        ),
        Positioned(
          top: 30,
          right: 5,
          child: OfflineWarningBadge(),
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

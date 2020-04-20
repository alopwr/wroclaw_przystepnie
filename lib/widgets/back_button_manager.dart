import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/places.dart';

class BackButtonManager extends StatelessWidget {
  final Widget child;

  BackButtonManager({@required this.child});

  Future<bool> exitDialog(BuildContext context) async {
    var exit = await showDialog(
        context: context,
        child: AlertDialog(
          title: const Text("Jesteś pewien?"),
          content: const Text("Czy na pewno chcesz opuścić tą aplikację?"),
          actions: <Widget>[
            FlatButton(
              child: const Text("Nie"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: const Text("Tak"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ));
    return exit;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        final places = Provider.of<Places>(context, listen: false);
        if (places.activePlace != null) {
          places.panelListScrollController.animateTo(1,
              duration: const Duration(milliseconds: 100),
              curve: Curves.fastOutSlowIn);
          places.panelController.close();
          places.showMenu(close: false);
          return Future.delayed(Duration.zero, () => false);
        } else if (!places.panelController.isPanelClosed) {
          places.panelListScrollController.animateTo(1,
              duration: const Duration(milliseconds: 100),
              curve: Curves.fastOutSlowIn);
          places.panelController.close();
          return Future.delayed(Duration.zero, () => false);
        }
        return exitDialog(context);
      },
      child: child,
    );
  }
}
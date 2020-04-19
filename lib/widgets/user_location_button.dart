import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_location.dart';

class UserLocationButton extends StatefulWidget {
  const UserLocationButton({
    Key key,
  }) : super(key: key);

  @override
  _UserLocationButtonState createState() => _UserLocationButtonState();
}

class _UserLocationButtonState extends State<UserLocationButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 300),
        firstChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator()),
          ],
        ),
        secondChild: const Icon(
          Icons.gps_fixed,
          color: Colors.blue,
        ),
        crossFadeState:
            loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      ),
      onPressed: () async {
        setState(() {
          loading = true;
        });
        final userLocationManager =
            Provider.of<UserLocationManager>(context, listen: false);
        await userLocationManager.permissionHandling();
        await userLocationManager.focusOnUser();
        setState(() {
          loading = false;
        });
      },
      backgroundColor: Colors.white,
    );
  }
}

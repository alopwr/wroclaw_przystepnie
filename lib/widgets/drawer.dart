import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer();

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<Auth>(context);

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: const Text(""),
            accountEmail: Row(
              children: <Widget>[
                const Icon(Icons.phone),
                Text(auth.phoneNumber ?? ""),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              if (ModalRoute.of(context).settings.name != '/')
                Navigator.of(context).pushReplacementNamed('/');
            },
            child: const ListTile(
              title: Text("Eksploruj"),
              leading: Icon(Icons.explore),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () async {
              await auth.logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
            },
            child: const ListTile(
              title: Text("Wyloguj się"),
              leading: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
    );
  }
}

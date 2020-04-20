import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/places.dart';
import 'providers/tracks.dart';
import 'providers/user_location.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Places>(
          create: (_) => Places(),
          update: (_, auth, __) => Places(auth: auth),
        ),
        ChangeNotifierProxyProvider<Places, UserLocationManager>(
          create: (_) => UserLocationManager(),
          update: (_, places, __) => UserLocationManager(places: places),
        ),
        ChangeNotifierProxyProvider<Auth, Tracks>(
          create: (_) => Tracks(),
          update: (_, auth, __) => Tracks(auth: auth),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Wrocław Przystępnie',
          theme: ThemeData(
              primarySwatch: Colors.orange, fontFamily: "Helvetica"),
          home: auth.loggingProcess
              ? Scaffold(
                  appBar: AppBar(title: const Text("Wrocław Przystępnie")),
                  body: const Center(child: CircularProgressIndicator()))
              : auth.isAuthed ? MapScreenLoader() : LoginScreen(),
        ),
      ),
    );
  }
}

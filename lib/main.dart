import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Wrocław Przystępnie',
          theme: ThemeData(primarySwatch: Colors.yellow),
          home: auth.loggingProcess
              ? Scaffold(
                  appBar: AppBar(title: const Text("Wrocław Przystępnie")),
                  body: const Center(child: CircularProgressIndicator()))
              : auth.isAuthed ? MapScreen() : LoginScreen(),
          routes: {},
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:wroclaw_przystepnie/widgets/back_button_manager.dart';

import 'providers/auth.dart';
import 'providers/places.dart';
import 'providers/tracks.dart';
import 'providers/user_location.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'sentry_message.dart';

final SentryClient _sentry = SentryClient(
    dsn:
        "https://07feea34da564fff9da2e62c2396e157@o367012.ingest.sentry.io/5205866");

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<Null> _reportSentryError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }
  print('Reporting to Sentry.io...');
  final Event event = await getSentryEnvEvent(error, stackTrace);
  final SentryResponse response = await _sentry.capture(event: event);

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}

void main() {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };
  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    await _reportSentryError(error, stackTrace);
  });
}

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
          theme:
              ThemeData(primarySwatch: Colors.orange, fontFamily: "Helvetica"),
          home: auth.loggingProcess
              ? Scaffold(
                  body: const SafeArea(
                      child: Center(child: CircularProgressIndicator())))
              : BackButtonManager(
                  child: auth.isAuthed ? MapScreenLoader() : LoginScreen(),
                ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';

import 'helpers/locator.dart';
import 'providers/auth.dart';
import 'providers/places.dart';
import 'providers/paths.dart';
import 'providers/user_location.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'sentry_message.dart';
import 'widgets/back_button_manager.dart';
import 'widgets/global_dialogs.dart';

final SentryClient _sentry = SentryClient(
    dsn:
        "https://07feea34da564fff9da2e62c2396e157@o367012.ingest.sentry.io/5205866");

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<Null> reportSentryError(dynamic error, dynamic stackTrace) async {
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
  setupLocator();
  runZoned<Future<Null>>(() async {
    await Hive.initFlutter();
    await Hive.openBox("cacheJson");
    // Future.delayed(Duration(seconds: 10), WidgetToImageConverter.captureWidget);
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    await reportSentryError(error, stackTrace);
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
          create: (_) => locator<Places>(),
          update: (_, auth, __) => newPlaces(auth: auth),
        ),
        ChangeNotifierProxyProvider<Places, UserLocationManager>(
          create: (_) => UserLocationManager(),
          update: (_, places, __) => UserLocationManager(places: places),
        ),
        ChangeNotifierProxyProvider<Auth, Paths>(
          create: (_) => locator<Paths>(),
          update: (_, auth, __) => newPaths(auth: auth),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Wrocław Przystępnie',
          theme:
              ThemeData(primarySwatch: Colors.orange, fontFamily: "Helvetica"),
          home: GlobalContextProvider(
            key: locator<GlobalKey<GlobalContextProviderState>>(),
            child: auth.loggingProcess
                ? Scaffold(
                    body: const SafeArea(
                        child: Center(child: CircularProgressIndicator())))
                : BackButtonManager(
                    child: auth.isAuthed ? MapScreenLoader() : LoginScreen(),
                  ),
          ),
        ),
      ),
    );
  }
}

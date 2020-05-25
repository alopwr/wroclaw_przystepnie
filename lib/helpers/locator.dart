import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../providers/auth.dart';
import '../providers/places.dart';
import '../providers/tracks.dart';
import '../widgets/global_dialogs.dart';

GetIt locator = GetIt.instance..allowReassignment = true;

void setupLocator() {
  locator.registerLazySingleton(() => GlobalKey<GlobalContextProviderState>());
  locator.registerLazySingleton(() => Tracks());
  locator.registerLazySingleton(() => Places());
}

Tracks newTracks({Auth auth}) {
  locator.registerSingleton(Tracks(auth: auth));
  return locator<Tracks>();
}

Places newPlaces({Auth auth}) {
  locator.registerSingleton(Places(auth: auth));
  return locator<Places>();
}

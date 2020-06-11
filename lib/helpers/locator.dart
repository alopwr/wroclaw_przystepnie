import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../providers/auth.dart';
import '../providers/places.dart';
import '../providers/paths.dart';
import '../widgets/global_dialogs.dart';

GetIt locator = GetIt.instance..allowReassignment = true;

void setupLocator() {
  locator.registerLazySingleton(() => GlobalKey<GlobalContextProviderState>());
  locator.registerLazySingleton(() => Paths());
  locator.registerLazySingleton(() => Places());
}

Paths newPaths({Auth auth}) {
  locator.registerSingleton(Paths(auth: auth));
  return locator<Paths>();
}

Places newPlaces({Auth auth}) {
  locator.registerSingleton(Places(auth: auth));
  return locator<Places>();
}

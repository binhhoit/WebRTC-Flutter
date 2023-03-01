import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';

import 'injection.config.dart';

final injector = GetIt.asNewInstance();

@InjectableInit(
  initializerName: 'registerDependencies',
  asExtension: true,
)
Future setupInjection(Environment env) async {
  await Hive.initFlutter();
  await PreferenceManager.init();
  injector.registerDependencies(environment: env.name);
}

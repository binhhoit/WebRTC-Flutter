import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/firebase_options.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';

import 'injection.config.dart';

final injector = GetIt.asNewInstance();

@InjectableInit(
  initializerName: 'registerDependencies',
  asExtension: true,
)
Future setupInjection(Environment env) async {
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  await PreferenceManager.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  injector.registerDependencies(environment: env.name);
}

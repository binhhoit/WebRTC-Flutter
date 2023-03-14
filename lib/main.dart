import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/firebase_options.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/app.dart';
import 'package:webrtc_flutter/ui/screens/auth/auth_bloc.dart';
import 'package:webrtc_flutter/ui/screens/call/login_bloc.dart';
import 'package:webrtc_flutter/utils/push_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await PushNotificationsManager.init();
  await setupInjection(
      const Environment(String.fromEnvironment('ENV_CONFIG', defaultValue: 'dev')));
  await EasyLocalization.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      fallbackLocale: const Locale('en', 'US'),
      path: 'assets/translations',
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CallBloc>(create: (BuildContext context) => injector.get()),
          BlocProvider<AuthenticationBloc>(create: (BuildContext context) => injector.get()),
        ],
        child: App(),
      ),
    ),
  );
}

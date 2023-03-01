import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/injection.dart';
import 'package:webrtc_flutter/ui/app.dart';
import 'package:webrtc_flutter/ui/screens/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjection(const Environment(
      String.fromEnvironment('ENV_CONFIG', defaultValue: 'dev')));
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en', 'US')],
      fallbackLocale: const Locale('en', 'US'),
      path: 'assets/translations',
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => injector.get(),
        child: App(),
      ),
    ),
  );
}

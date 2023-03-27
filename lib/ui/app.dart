import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webrtc_flutter/ui/screens/auth/auth_bloc.dart';
import 'package:webrtc_flutter/ui/screens/auth/auth_state.dart';
import 'package:webrtc_flutter/ui/screens/home/home_screen.dart';
import 'package:webrtc_flutter/ui/screens/login/login_screen.dart';
import 'package:webrtc_flutter/ui/screens/splash/splash_screen.dart';

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('vi', 'VN'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MaterialApp(
          navigatorKey: _navigatorKey,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                state.when(
                    unknown: () {},
                    unauthenticated: () {
                      _navigator.pushAndRemoveUntil(
                          MaterialPageRoute<void>(builder: (_) => LoginScreen()), (route) => false);
                    },
                    authenticated: () {
                      _navigator.pushAndRemoveUntil(
                          MaterialPageRoute<void>(builder: (_) => HomeScreen()), (route) => false);
                    });
              },
              child: child,
            );
          },
          onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => const SplashScreen())),
    );
  }
}

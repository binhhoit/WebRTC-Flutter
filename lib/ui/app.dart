import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webrtc_flutter/ui/screens/auth/auth_bloc.dart';
import 'package:webrtc_flutter/ui/screens/auth/auth_state.dart';
import 'package:webrtc_flutter/ui/screens/call_sample/call_screen.dart';
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
    FlutterCallkitIncoming.onEvent.listen(_callEventHandle);
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
        onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => const SplashScreen()),
      ),
    );
  }

  _callEventHandle(CallEvent? event) {
    switch (event!.event) {
      case Event.ACTION_CALL_INCOMING:
// TODO: received an incoming call
        break;
      case Event.ACTION_CALL_START:
// TODO: started an outgoing call
// TODO: show screen calling in Flutter
        break;
      case Event.ACTION_CALL_ACCEPT:
        _navigator.pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => CallScreen(host: "web-rtc-ktor.herokuapp.com")),
            (route) => false);
        Fluttertoast.showToast(
            msg: 'Accept Call}',
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16);
        print(event.body.toString());
        break;
      case Event.ACTION_CALL_DECLINE:
// TODO: declined an incoming call
        break;
      case Event.ACTION_CALL_ENDED:
// TODO: ended an incoming/outgoing call
        break;
      case Event.ACTION_CALL_TIMEOUT:
// TODO: missed an incoming call
        break;
      case Event.ACTION_CALL_CALLBACK:
// TODO: only Android - click action `Call back` from missed call notification
        break;
      case Event.ACTION_CALL_TOGGLE_HOLD:
// TODO: only iOS
        break;
      case Event.ACTION_CALL_TOGGLE_MUTE:
// TODO: only iOS
        break;
      case Event.ACTION_CALL_TOGGLE_DMTF:
// TODO: only iOS
        break;
      case Event.ACTION_CALL_TOGGLE_GROUP:
// TODO: only iOS
        break;
      case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
// TODO: only iOS
        break;
      case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
// TODO: only iOS
        break;
    }
  }
}

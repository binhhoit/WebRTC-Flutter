import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/enums.dart';
import 'package:webrtc_flutter/domain/usecases/auth_usecase.dart';
import 'package:webrtc_flutter/platform/helpers/reactive_auth_status.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';

@Injectable(as: AuthenticationUseCase)
class AuthenticationUseCaseImpl extends AuthenticationUseCase {
  AuthenticationUseCaseImpl() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (firebase.FirebaseAuth.instance.currentUser != null) {
        reactiveAuthStatus.value = AuthenticationStatus.authenticated;
      } else {
        reactiveAuthStatus.value = AuthenticationStatus.unauthenticated;
      }
    });
  }

  @override
  StreamSubscription<AuthenticationStatus> listenAuthStatus(
      Function(AuthenticationStatus status) onStatusChanged) {
    return reactiveAuthStatus.listen((value) {
      onStatusChanged(value);
    });
  }

  @override
  Future<void> logOut() async {
    //TODO: Impl Logout
    //Fake login
    await Future.delayed(const Duration(seconds: 1));
    await PreferenceManager.instance.clear();
    reactiveAuthStatus.value = AuthenticationStatus.unauthenticated;
  }

  @override
  Future<void> login() async {
    //TODO: Impl Login
    //Fake login
    await Future.delayed(const Duration(seconds: 1));
    PreferenceManager.instance.accessToken = 'mock';
    reactiveAuthStatus.value = AuthenticationStatus.authenticated;
  }

  @override
  bool isLoggedIn() {
    return PreferenceManager.instance.isLoggedIn;
  }
}

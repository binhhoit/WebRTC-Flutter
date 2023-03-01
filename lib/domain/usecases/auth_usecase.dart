import 'dart:async';

import 'package:webrtc_flutter/domain/entities/enums.dart';

abstract class AuthenticationUseCase {
  Future<void> login();
  Future<void> logOut();
  StreamSubscription<AuthenticationStatus> listenAuthStatus(Function(AuthenticationStatus status) onStatusChanged);
  bool isLoggedIn();
}
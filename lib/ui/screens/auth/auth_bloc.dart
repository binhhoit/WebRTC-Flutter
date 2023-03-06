import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/enums.dart';
import 'package:webrtc_flutter/domain/usecases/auth_usecase.dart';
import 'package:webrtc_flutter/domain/usecases/user_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationUseCase authenticationUseCase;
  final UserUseCase userUseCase;

  AuthenticationBloc(this.authenticationUseCase, this.userUseCase)
      : super(const AuthenticationState.unknown()) {
    on<AuthEventStatusChanged>(_onAuthenticationStatusChanged);
    on<AuthEventLogoutRequested>(_onAuthenticationLogoutRequested);
    _authenticationStatusSubscription = authenticationUseCase.listenAuthStatus((status) {
      add(AuthenticationEvent.statusChanged(status));
    });
  }

  late StreamSubscription<AuthenticationStatus> _authenticationStatusSubscription;

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    return super.close();
  }

  Future<void> _onAuthenticationStatusChanged(
    AuthEventStatusChanged event,
    Emitter<AuthenticationState> emit,
  ) async {
    switch (event.status) {
      case AuthenticationStatus.unauthenticated:
        return emit(const AuthenticationState.unauthenticated());
      case AuthenticationStatus.authenticated:
        return emit(const AuthenticationState.authenticated());
      case AuthenticationStatus.unknown:
        return emit(const AuthenticationState.unknown());
      case AuthenticationStatus.silentAuthenticated:
        break;
    }
  }

  void _onAuthenticationLogoutRequested(
    AuthEventLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    authenticationUseCase.logOut();
  }
}

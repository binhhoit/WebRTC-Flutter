import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webrtc_flutter/domain/entities/enums.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.statusChanged(AuthenticationStatus status) = AuthEventStatusChanged;
  const factory AuthenticationEvent.logoutRequested () = AuthEventLogoutRequested;
}
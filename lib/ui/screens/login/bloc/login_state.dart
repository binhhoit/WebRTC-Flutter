import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.loading() = LoginLoading;
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.error(String message) = LoginError;
}
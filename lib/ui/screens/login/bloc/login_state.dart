import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.init() = LoginInit;
  const factory LoginState.loading() = LoginLoading;
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.error(String message) = LoginError;
  const factory LoginState.validated() = LoginInputValidated;
}

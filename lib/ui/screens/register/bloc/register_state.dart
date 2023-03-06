import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState.init() = RegisterInit;
  const factory RegisterState.loading() = RegisterLoading;
  const factory RegisterState.idle() = RegisterIdle;
  const factory RegisterState.error(String message) = RegisterError;
  const factory RegisterState.validated() = RegisterInputValidated;
}

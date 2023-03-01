import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.unknown() = UnknownAuth;
  const factory AuthenticationState.unauthenticated () = Unauthenticated;
  const factory AuthenticationState.authenticated () = Authenticated;
}
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.idle({User? data}) = HomeIdle;
  const factory HomeState.error(String message) = HomeError;
}
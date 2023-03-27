import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webrtc_flutter/domain/entities/room/room.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.init() = HomeInit;
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.idle() = HomeIdle;
  const factory HomeState.error(String message) = HomeError;
  const factory HomeState.users(List<User> users) = UserData;
  const factory HomeState.rooms(List<Room> rooms) = RoomData;
  const factory HomeState.currentUser(User user) = CurrentUser;
  const factory HomeState.myCall(Room room) = MyCall;
}

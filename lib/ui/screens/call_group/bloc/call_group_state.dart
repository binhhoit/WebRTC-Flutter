import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webrtc_flutter/domain/entities/room/room.dart';

part 'call_group_state.freezed.dart';

@freezed
class CallGroupState with _$CallGroupState {
  const factory CallGroupState.init() = CallGroupInit;
  const factory CallGroupState.loading() = CallGroupLoading;
  const factory CallGroupState.idle() = CallGroupIdle;
  const factory CallGroupState.error(String message) = CallGroupError;
  const factory CallGroupState.room(Room room) = CallGroupRoom;
  const factory CallGroupState.closeRoom() = CloseRoom;
}

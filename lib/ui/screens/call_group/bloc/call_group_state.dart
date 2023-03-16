import 'package:freezed_annotation/freezed_annotation.dart';

part 'call_group_state.freezed.dart';

@freezed
class CallGroupState with _$CallGroupState {
  const factory CallGroupState.init() = CallGroupInit;
  const factory CallGroupState.loading() = CallGroupLoading;
  const factory CallGroupState.idle() = CallGroupIdle;
  const factory CallGroupState.error(String message) = CallGroupError;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:webrtc_flutter/domain/entities/result/failures/failure.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result {
  // Common Failures
  const factory Result.success(T? data) = ResultSuccess<T>;
  const factory Result.error(Failure failure) = ResultError<T>;
}

extension ResultEx<T> on Result<T> {
  bool get isSuccess => this is ResultSuccess<T>;
  bool get isFail => this is ResultError<T>;
}
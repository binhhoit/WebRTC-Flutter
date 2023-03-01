import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  // Common Failures
  const factory Failure.noInternetConnectionFound() = NoInternetConnectionFound;
  const factory Failure.serverNotResponse() = ServerNotResponse;
  const factory Failure.unAuthenticated() = TokenExpired;
  const factory Failure.unknownFailure() = UnknownFailure;
  const factory Failure.invalidInputValue({required dynamic type}) = InvalidInputValue;
  const factory Failure.httpFailure({required int code, required String msg}) = HttpFailure;
}
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:webrtc_flutter/domain/common/exceptions.dart';
import 'package:webrtc_flutter/domain/entities/result/failures/failure.dart';
import 'package:webrtc_flutter/domain/entities/result/result.dart';

typedef ResponseToModel<T> = T Function(dynamic);

class HandleNetworkMixin {
  Failure _handleError(Exception error) {
    if (error is DioError) {
      DioError dioError = error;
      switch (dioError.type) {
        case DioErrorType.cancel:
        case DioErrorType.connectTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.response:
          if (dioError.response?.statusCode == 401) {
            return const Failure.unAuthenticated();
          }
          return Failure.httpFailure(
              code: dioError.response?.statusCode ?? 400,
              msg: dioError.response?.statusMessage ?? "");
        case DioErrorType.other:
          if (dioError.error is ConnectionException) {
            return const Failure.noInternetConnectionFound();
          }
          if (dioError.error is SocketException) {
            return const Failure.noInternetConnectionFound();
          }
          return const Failure.serverNotResponse();
      }
    } else {
      return const Failure.unknownFailure();
    }
  }

  Future<Result<T>> makeRequest<T>({
    required Future<dynamic> call,
    required ResponseToModel<T> toModel,
  }) async {
    try {
      var response = await call;
      return ResultSuccess<T>(toModel.call(response));
    } on Exception catch (exception) {
      return ResultError(_handleError(exception));
    }
  }
}

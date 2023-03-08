import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:webrtc_flutter/platform/network/http/response_transformer.dart';
import 'package:webrtc_flutter/platform/network/intercepter/connectivity_interceptor.dart';
import 'package:webrtc_flutter/platform/network/intercepter/token_intercepter.dart';

@module
abstract class NetworkModule {
  @injectable
  Dio getDio(
    ResponseTransformer transformer,
    TokenInterceptor tokenInterceptor,
    ConnectivityInterceptor connectivityInterceptor,
  ) {
    final logger = PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: false,
      responseHeader: false,
      compact: false,
    );
    var dio = Dio(BaseOptions(connectTimeout: 10000, receiveTimeout: 10000));
    dio.transformer = transformer;
    dio.interceptors.add(tokenInterceptor);
    dio.interceptors.add(connectivityInterceptor);
    dio.interceptors.add(logger);
    return dio;
  }
}

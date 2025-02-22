import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:webrtc_flutter/platform/config/build_config.dart';

part 'api_client.g.dart';

@injectable
@RestApi()
abstract class ApiClient {
  @factoryMethod
  factory ApiClient(
    BuildConfig buildConfig,
    Dio dio,
  ) {
    return _ApiClient(dio, baseUrl: buildConfig.baseUrl);
  }

  @POST("sendFCMToken")
  Future sendFCMToken(@Queries(encoded: false) Map<String, dynamic> queryParams);

  @POST("declined_call")
  Future declinedCall(@Queries(encoded: false) Map<String, dynamic> sessionIdParams);
}

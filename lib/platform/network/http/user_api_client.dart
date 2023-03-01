import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:webrtc_flutter/platform/config/build_config.dart';
import 'package:webrtc_flutter/platform/model/request/profile_response.dart';
import 'package:webrtc_flutter/platform/model/response/search_user_response/search_user_response.dart';

part 'user_api_client.g.dart';

@injectable
@RestApi()
abstract class UserApiClient {
  @factoryMethod
  factory UserApiClient(
      BuildConfig buildConfig,
      Dio dio,
      ) {
    return _UserApiClient(dio, baseUrl: buildConfig.baseUrl);
  }

  @GET("b3e92c11-3893-49b5-a7ec-ab75a6205584")
  Future<ProfileResponse> getProfile();

}

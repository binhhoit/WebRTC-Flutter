import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';

@injectable
class TokenInterceptor extends InterceptorsWrapper {

  final PreferenceManager _preferencesManager;

  TokenInterceptor(this._preferencesManager);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = _preferencesManager.accessToken;
    options.headers['Authorization'] = "Bearer $token";
    return super.onRequest(options, handler);
  }

}

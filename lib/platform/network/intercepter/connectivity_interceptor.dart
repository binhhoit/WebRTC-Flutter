import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/common/exceptions.dart';

@injectable
class ConnectivityInterceptor extends InterceptorsWrapper {

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    var netWorkStatus = await Connectivity().checkConnectivity();
    if (netWorkStatus == ConnectivityResult.none) {
      return handler.reject(DioError(requestOptions: options, error: ConnectionException(), type: DioErrorType.other));
    }
    return super.onRequest(options, handler);
  }

}
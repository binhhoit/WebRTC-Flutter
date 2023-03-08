import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/repositories/data_repository.dart';
import 'package:webrtc_flutter/platform/helpers/handle_networt_mixin.dart';
import 'package:webrtc_flutter/platform/network/http/api_client.dart';

@Injectable(as: DataRepository)
class DataRepositoryImpl extends DataRepository with HandleNetworkMixin {
  final ApiClient apiClient;

  DataRepositoryImpl(this.apiClient);

  @override
  Future<void> sentFCMToken(Map<String, dynamic> queryParams) {
    return apiClient.sendFCMToken(queryParams);
  }
}

import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/result/result.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository.dart';
import 'package:webrtc_flutter/platform/helpers/handle_networt_mixin.dart';
import 'package:webrtc_flutter/platform/model/request/profile_response.dart';
import 'package:webrtc_flutter/platform/network/http/user_api_client.dart';

@Injectable(as: UserRepository)
class UserRepositoryImpl extends UserRepository with HandleNetworkMixin {
  final UserApiClient userApiClient;

  UserRepositoryImpl(this.userApiClient);

  @override
  Future<Result<User>> getProfile() async {
    return makeRequest<User>(
      call: userApiClient.getProfile(),
      toModel: (data) {
        return (data as ProfileResponse).data;
      },
    );
  }
}

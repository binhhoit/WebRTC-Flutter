import 'package:webrtc_flutter/domain/entities/result/result.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';

abstract class UserRepository {
  Future<Result<User>> getProfile();
}
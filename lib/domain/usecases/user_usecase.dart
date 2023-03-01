import 'package:webrtc_flutter/domain/entities/result/result.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/domain/entities/user/users_result.dart';

abstract class UserUseCase {
  Future<Result<User>> getProfile();
}
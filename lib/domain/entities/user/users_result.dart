import 'package:webrtc_flutter/domain/entities/user/user.dart';

class UsersResult {
  final int page;
  final List<User> users;

  UsersResult({required this.page, required this.users});
}
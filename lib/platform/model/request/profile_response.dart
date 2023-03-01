import 'package:json_annotation/json_annotation.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  int code;

  String message;

  User data;

  ProfileResponse({required this.code, required this.data, required this.message});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => _$ProfileResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileResponseToJson(this);
}


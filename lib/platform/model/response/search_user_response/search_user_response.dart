import 'package:json_annotation/json_annotation.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';

part 'search_user_response.g.dart'; 

@JsonSerializable()
class SearchUserResponse {
  @JsonKey(name: 'total_count')
  int? totalCount;
  @JsonKey(name: 'incomplete_results')
  bool? incompleteResults;
  @JsonKey(name: 'items')
  List<User>? users;

  SearchUserResponse({this.totalCount, this.incompleteResults, this.users});

   factory SearchUserResponse.fromJson(Map<String, dynamic> json) => _$SearchUserResponseFromJson(json);

   Map<String, dynamic> toJson() => _$SearchUserResponseToJson(this);
}

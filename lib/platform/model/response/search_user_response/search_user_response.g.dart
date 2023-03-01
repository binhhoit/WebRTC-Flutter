// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchUserResponse _$SearchUserResponseFromJson(Map<String, dynamic> json) =>
    SearchUserResponse(
      totalCount: json['total_count'] as int?,
      incompleteResults: json['incomplete_results'] as bool?,
      users: (json['items'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchUserResponseToJson(SearchUserResponse instance) =>
    <String, dynamic>{
      'total_count': instance.totalCount,
      'incomplete_results': instance.incompleteResults,
      'items': instance.users,
    };

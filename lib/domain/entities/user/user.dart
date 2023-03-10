import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User extends HiveObject with _$User {
  User._();

  @HiveType(typeId: 1, adapterName: 'UserAdapter')
  factory User({
    @HiveField(0) required String id,
    @HiveField(1) required String avatar,
    @HiveField(2) required String email,
    @HiveField(3) required String name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

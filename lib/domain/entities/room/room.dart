import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
class Room extends HiveObject with _$Room {
  Room._();

  @HiveType(typeId: 1, adapterName: 'RoomAdapter')
  factory Room({
    @HiveField(0) required String id,
    @HiveField(1) required List<String> idUsers,
    @HiveField(2) required String from,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/room/room.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/platform/config/build_config.dart';
import 'package:webrtc_flutter/platform/local/preferences/preference_manager.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_state.dart';
import 'package:webrtc_flutter/utils/notification_utils.dart';

@injectable
class HomeBloc extends Cubit<HomeState> {
  BuildConfig buildConfig;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final _currentId = PreferenceManager.instance.currentUser.id;
  final _users = <User>[];
  final showNotify = [];

  HomeBloc(this.buildConfig) : super(const HomeState.init()) {
    _getListUser();
    _getListRoom();
  }

  final databaseReference = FirebaseFirestore.instance;

  String getBaseUrlServer() => buildConfig.baseUrl;

  Future<void> _getListUser() async {
    emit(const HomeState.loading());
    var id = fireAuth.FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      final users = <User>[];
      await databaseReference.collection('users').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          final user = User.fromJson(doc.data());
          if (user.id == id) {
            PreferenceManager.instance.currentUser = user;
            emit(HomeState.currentUser(user));
          } else {
            users.add(user);
            _users.add(user);
          }
        }

        emit(HomeState.users(users));
      }, onError: (e) {
        print(e);
        emit(HomeState.error(e.toString()));
      });
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> _getListRoom() async {
    emit(const HomeState.loading());
    try {
      _database.child('rooms').onValue.listen((event) {
        final rooms = <Room>[];
        for (var doc in event.snapshot.children) {
          try {
            final room = Room.fromJson(jsonDecode(jsonEncode(doc.value)));
            if (room.idUsers.contains(_currentId)) {
              if (room.idUsers.length == 2) {
                if (room.from != _currentId) repairDataNotify(room);
              } else {
                rooms.add(room);
              }
            }
          } catch (e) {}
        }
        if (!isClosed) {
          emit(HomeState.rooms(rooms));
        }
      }, onError: (e) {
        print(e);
        emit(HomeState.error(e.toString()));
      });
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }

  Future<void> repairDataNotify(Room room) async {
    if (!showNotify.contains(room.id)) {
      showNotify.add(room.id);
      var idUserCall = room.idUsers.where((id) => id != _currentId).first;
      var userSnap = await databaseReference.collection('users').doc(idUserCall).get();
      final user = User.fromJson(userSnap.data()!);
      var map = <String, dynamic>{
        'extra': {'sessionId': room.id},
        'data': {
          'nameCaller': user.name,
          'avatar': user.avatar,
          'roomId': room.id,
          'idUsers': room.idUsers
        }
      };
      var message = RemoteMessage.fromMap(map);
      NotificationUtils.showCallkitIncoming(message);
    }
  }

  Future<void> sendByeUser(String idRoom) async {
    await _database.child('rooms/$idRoom/bye').set({'bye': true});
  }
}

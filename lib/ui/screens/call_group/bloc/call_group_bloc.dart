import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/room/room.dart';
import 'package:webrtc_flutter/platform/config/build_config.dart';
import 'package:webrtc_flutter/ui/screens/call_group/bloc/call_group_state.dart';

@injectable
class CallGroupBloc extends Cubit<CallGroupState> {
  BuildConfig buildConfig;

  CallGroupBloc(this.buildConfig) : super(const CallGroupState.init()) {
    getRooms();
  }

  final databaseReference = FirebaseFirestore.instance;

  String getBaseUrlServer() => buildConfig.baseUrl;

  Future<void> createRoom(String idRoom, List<String> idUsers) async {
    try {
      await databaseReference.collection('rooms').doc(idRoom).set({
        'id': idRoom,
        'idUsers': idUsers,
      });
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }

  Future<void> getRooms() async {
    emit(const CallGroupState.loading());
    var id = fireAuth.FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      databaseReference.collection('rooms').snapshots().listen((snapshot) {
        final rooms = <Room>[];
        for (var doc in snapshot.docs) {
          final room = Room.fromJson(doc.data());
          rooms.add(room);
        }
      }, onError: (e) {
        print(e);
        emit(CallGroupState.error(e.toString()));
      });
    } catch (e) {
      emit(CallGroupState.error(e.toString()));
    }
  }
}

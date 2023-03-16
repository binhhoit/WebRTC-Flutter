import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
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

  Future<void> getRooms() async {
    emit(const CallGroupState.loading());
    var id = fireAuth.FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      await databaseReference.collection('rooms').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          final user = User.fromJson(doc.data());
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

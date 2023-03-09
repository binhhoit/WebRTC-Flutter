import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/platform/config/build_config.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_state.dart';

@injectable
class HomeBloc extends Cubit<HomeState> {
  BuildConfig buildConfig;

  HomeBloc(this.buildConfig) : super(const HomeState.init()) {
    getListUser();
  }

  final databaseReference = FirebaseFirestore.instance;

  String getBaseUrlServer() => buildConfig.baseUrl;

  Future<void> getListUser() async {
    emit(const HomeState.loading());
    var id = fireAuth.FirebaseAuth.instance.currentUser?.uid ?? "";
    try {
      final users = <User>[];
      await databaseReference.collection('users').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          final user = User.fromJson(doc.data());
          if (user.id == id) {
            emit(HomeState.currentUser(user));
          } else {
            users.add(user);
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
}

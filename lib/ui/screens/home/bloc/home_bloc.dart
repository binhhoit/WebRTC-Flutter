import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/entities/user/user.dart';
import 'package:webrtc_flutter/ui/screens/home/bloc/home_state.dart';

@injectable
class HomeBloc extends Cubit<HomeState> {
  HomeBloc() : super(const HomeState.init()) {
    getListUser();
  }

  final databaseReference = FirebaseFirestore.instance;

  Future<void> getListUser() async {
    emit(const HomeState.loading());
    try {
      final users = <User>[];
      await databaseReference.collection('users').get().then((snapshot) {
        for (var doc in snapshot.docs) {
          final user = User.fromJson(doc.data());
          users.add(user);
        }
        emit(HomeState.users(users));
      }, onError: (e) {
        emit(HomeState.error(e.toString()));
      });
    } catch (e) {
      emit(HomeState.error(e.toString()));
    }
  }
}

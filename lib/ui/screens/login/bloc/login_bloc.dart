import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/usecases/fcm_usecase.dart';
import 'package:webrtc_flutter/domain/usecases/login_usecase.dart';

import 'login_state.dart';

@injectable
class LoginBloc extends Cubit<LoginState> {
  LoginUseCase loginUseCase;
  FCMUseCase fcmUseCase;

  LoginBloc(this.loginUseCase, this.fcmUseCase) : super(const LoginInit());

  Future<void> loginAction({required String email, required String pass}) async {
    emit(const LoginState.loading());
    try {
      await loginUseCase.loginWithGmail(email: email, pass: pass);
      var fcm = await FirebaseMessaging.instance.getToken();
      if (fcm != null) await fcmUseCase.sendFCMToken({'fcmToken': fcm});
      emit(const LoginState.validated());
    } catch (e) {
      emit(LoginState.error(e.toString()));
    }
  }
}

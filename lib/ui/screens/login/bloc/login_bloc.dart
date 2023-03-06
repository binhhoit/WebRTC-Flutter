import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/usecases/login_usecase.dart';

import 'login_state.dart';

@injectable
class LoginBloc extends Cubit<LoginState> {
  LoginUseCase loginUseCase;

  LoginBloc(this.loginUseCase) : super(const LoginInit());

  Future<void> loginAction({required String email, required String pass}) async {
    emit(const LoginState.loading());
    try {
      await loginUseCase.loginWithGmail(email: email, pass: pass);
      emit(const LoginState.validated());
    } catch (e) {
      emit(LoginState.error(e.toString()));
    }
  }
}

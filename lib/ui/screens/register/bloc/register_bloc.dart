import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/usecases/register_usecase.dart';

import 'register_state.dart';

@injectable
class RegisterBloc extends Cubit<RegisterState> {
  RegisterUseCase registerUseCase;

  RegisterBloc(this.registerUseCase) : super(const RegisterInit());

  Future<void> registerAccount(
      {required String email, required String pass, required String passConfirm}) async {
    emit(const RegisterState.loading());
    if (pass != passConfirm) {
      emit(const RegisterState.error("Password does not match"));
    } else {
      try {
        await registerUseCase.registerWithGmail(email: email, pass: pass);
        emit(const RegisterState.validated());
      } catch (e) {
        emit(RegisterState.error(e.toString()));
      }
    }
  }
}

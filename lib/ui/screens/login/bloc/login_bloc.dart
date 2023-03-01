import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/usecases/auth_usecase.dart';
import 'package:webrtc_flutter/ui/screens/login/bloc/login_event.dart';
import 'package:webrtc_flutter/ui/screens/login/bloc/login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState>{

  final AuthenticationUseCase authenticationUseCase;

  LoginBloc(this.authenticationUseCase): super(const LoginState.idle()) {
    on<RequestLogin>(_onRequestLogin) ;
  }

  Future<void> _onRequestLogin(
      RequestLogin event,
      Emitter<LoginState> emit,
      ) async {
    emit(const LoginState.loading());
    await authenticationUseCase.login();
    emit(const LoginState.idle());
  }

}
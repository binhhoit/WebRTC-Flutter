import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository.dart';
import 'package:webrtc_flutter/domain/usecases/login_usecase.dart';

@Injectable(as: LoginUseCase)
class LoginUseCaseImpl extends LoginUseCase {
  final UserRepository _userRepository;

  LoginUseCaseImpl(this._userRepository);

  @override
  Future<bool> loginWithGmail({String email = "", String pass = ""}) async {
    return await _userRepository.loginWithGmail(email, pass);
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}

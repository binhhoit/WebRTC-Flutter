import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository.dart';
import 'package:webrtc_flutter/domain/usecases/register_usecase.dart';

@Injectable(as: RegisterUseCase)
class RegisterUseCaseImpl extends RegisterUseCase {
  final UserRepository _userRepository;

  RegisterUseCaseImpl(this._userRepository);

  @override
  Future<bool> registerWithGmail({required String email, required String pass}) async {
    return await _userRepository.registerWithGmail(email, pass);
  }
}

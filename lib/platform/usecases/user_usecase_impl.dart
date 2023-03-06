import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/repositories/user_repository.dart';
import 'package:webrtc_flutter/domain/usecases/user_usecase.dart';

@Injectable(as: UserUseCase)
class UserUseCaseImpl extends UserUseCase {
  final UserRepository userRepository;

  UserUseCaseImpl(this.userRepository);
}

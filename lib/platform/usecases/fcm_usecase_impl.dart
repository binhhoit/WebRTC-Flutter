import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/repositories/data_repository.dart';
import 'package:webrtc_flutter/domain/usecases/fcm_usecase.dart';

@Injectable(as: FCMUseCase)
class FCMUseCaseImpl extends FCMUseCase {
  final DataRepository dataRepository;

  FCMUseCaseImpl(this.dataRepository);

  @override
  Future<void> sendFCMToken(Map<String, dynamic> queryParams) async {
    dataRepository.sentFCMToken(queryParams);
  }
}

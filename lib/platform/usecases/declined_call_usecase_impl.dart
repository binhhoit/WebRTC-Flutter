import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/repositories/data_repository.dart';
import 'package:webrtc_flutter/domain/usecases/declined_call_usecase.dart';

@Injectable(as: DeclinedCallUseCase)
class DeclinedCallUseCaseImpl extends DeclinedCallUseCase {
  final DataRepository dataRepository;

  DeclinedCallUseCaseImpl(this.dataRepository);

  @override
  Future<void> declinedCall(String sessionId) async {
    await dataRepository.declinedCall({'sessionId': sessionId});
  }
}

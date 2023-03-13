import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/usecases/declined_call_usecase.dart';

@injectable
class CallBloc extends Cubit {
  DeclinedCallUseCase declinedCallUseCase;

  CallBloc(this.declinedCallUseCase) : super(null);

  Future<void> declinedCall({required String sessionId}) async {
    await declinedCallUseCase.declinedCall(sessionId);
  }
}

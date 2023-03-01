import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:webrtc_flutter/domain/usecases/user_usecase.dart';

import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserUseCase userUseCase;

  HomeBloc(this.userUseCase) : super(const HomeState.idle()) {
    on<FetchProfile>((event, emit) async {
      emit(const HomeState.loading());
      var result = await userUseCase.getProfile();
      result.when(
          success: (user) {
            emit(HomeState.idle(data: user));
          },
          error: (error) {
            emit(HomeState.error(error.toString()));
          });
    });
  }
}

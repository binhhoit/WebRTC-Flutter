// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i11;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'domain/repositories/user_repository.dart' as _i13;
import 'domain/usecases/auth_usecase.dart' as _i3;
import 'domain/usecases/user_usecase.dart' as _i15;
import 'platform/config/build_config.dart' as _i5;
import 'platform/di/network_module.dart' as _i19;
import 'platform/local/preferences/preference_manager.dart' as _i8;
import 'platform/network/http/response_transformer.dart' as _i9;
import 'platform/network/http/user_api_client.dart' as _i12;
import 'platform/network/intercepter/connectivity_interceptor.dart' as _i6;
import 'platform/network/intercepter/token_intercepter.dart' as _i10;
import 'platform/repositories/user_repository_impl.dart' as _i14;
import 'platform/usecases/auth_usecase_impl.dart' as _i4;
import 'platform/usecases/user_usecase_impl.dart' as _i16;
import 'ui/screens/auth/auth_bloc.dart' as _i17;
import 'ui/screens/home/bloc/home_bloc.dart' as _i18;
import 'ui/screens/login/bloc/login_bloc.dart' as _i7;

const String _dev = 'dev';
const String _test = 'test';
const String _prod = 'prod';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
/// an extension to register the provided dependencies inside of [GetIt]
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of provided dependencies inside of [GetIt]
  _i1.GetIt registerDependencies({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final networkModule = _$NetworkModule();
    gh.factory<_i3.AuthenticationUseCase>(
        () => _i4.AuthenticationUseCaseImpl());
    gh.factory<_i5.BuildConfig>(
      () => _i5.DevBuildConfig(),
      registerFor: {_dev},
    );
    gh.factory<_i5.BuildConfig>(
      () => _i5.StagingBuildConfig(),
      registerFor: {_test},
    );
    gh.factory<_i5.BuildConfig>(
      () => _i5.ProdBuildConfig(),
      registerFor: {_prod},
    );
    gh.factory<_i6.ConnectivityInterceptor>(
        () => _i6.ConnectivityInterceptor());
    gh.factory<_i7.LoginBloc>(
        () => _i7.LoginBloc(get<_i3.AuthenticationUseCase>()));
    gh.lazySingleton<_i8.PreferenceManager>(
        () => _i8.PreferenceManager.create());
    gh.factory<_i9.ResponseTransformer>(() => _i9.ResponseTransformer());
    gh.factory<_i10.TokenInterceptor>(
        () => _i10.TokenInterceptor(get<_i8.PreferenceManager>()));
    gh.factory<_i11.Dio>(() => networkModule.getDio(
          get<_i9.ResponseTransformer>(),
          get<_i10.TokenInterceptor>(),
          get<_i6.ConnectivityInterceptor>(),
        ));
    gh.factory<_i12.UserApiClient>(() => _i12.UserApiClient(
          get<_i5.BuildConfig>(),
          get<_i11.Dio>(),
        ));
    gh.factory<_i13.UserRepository>(
        () => _i14.UserRepositoryImpl(get<_i12.UserApiClient>()));
    gh.factory<_i15.UserUseCase>(
        () => _i16.UserUseCaseImpl(get<_i13.UserRepository>()));
    gh.factory<_i17.AuthenticationBloc>(() => _i17.AuthenticationBloc(
          get<_i3.AuthenticationUseCase>(),
          get<_i15.UserUseCase>(),
        ));
    gh.factory<_i18.HomeBloc>(() => _i18.HomeBloc(get<_i15.UserUseCase>()));
    return this;
  }
}

class _$NetworkModule extends _i19.NetworkModule {}

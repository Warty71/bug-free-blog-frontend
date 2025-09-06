// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bug_free_blog_frontend/core/di/dio_module.dart' as _i395;
import 'package:bug_free_blog_frontend/core/network/api_client.dart' as _i568;
import 'package:bug_free_blog_frontend/core/network/network_info.dart' as _i941;
import 'package:bug_free_blog_frontend/core/network/token_storage.dart'
    as _i838;
import 'package:bug_free_blog_frontend/features/auth/data/datasources/auth_api_service.dart'
    as _i476;
import 'package:bug_free_blog_frontend/features/auth/data/repositories/auth_repository_impl.dart'
    as _i751;
import 'package:bug_free_blog_frontend/features/auth/domain/repositories/auth_repository.dart'
    as _i366;
import 'package:bug_free_blog_frontend/features/auth/domain/usecases/get_current_user_usecase.dart'
    as _i503;
import 'package:bug_free_blog_frontend/features/auth/domain/usecases/login_usecase.dart'
    as _i1053;
import 'package:bug_free_blog_frontend/features/auth/domain/usecases/register_usecase.dart'
    as _i277;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final dioModule = _$DioModule();
    gh.singleton<_i568.ApiClient>(() => _i568.ApiClient());
    gh.singleton<_i838.TokenStorage>(() => _i838.TokenStorage());
    gh.singleton<_i361.Dio>(
      () => dioModule.authenticatedDio,
      instanceName: 'authenticatedDio',
    );
    gh.singleton<_i361.Dio>(() => dioModule.authDio, instanceName: 'authDio');
    gh.lazySingleton<_i941.NetworkInfo>(() => _i941.NetworkInfoImpl());
    gh.factory<_i476.AuthApiService>(
      () => _i476.AuthApiService.new(
        gh<_i361.Dio>(instanceName: 'authenticatedDio'),
      ),
    );
    gh.lazySingleton<_i366.AuthRepository>(
      () => _i751.AuthRepositoryImpl(
        gh<_i476.AuthApiService>(),
        gh<_i941.NetworkInfo>(),
        gh<_i838.TokenStorage>(),
      ),
    );
    gh.factory<_i277.RegisterUseCase>(
      () => _i277.RegisterUseCase(gh<_i366.AuthRepository>()),
    );
    gh.factory<_i1053.LoginUseCase>(
      () => _i1053.LoginUseCase(gh<_i366.AuthRepository>()),
    );
    gh.factory<_i503.GetCurrentUserUseCase>(
      () => _i503.GetCurrentUserUseCase(gh<_i366.AuthRepository>()),
    );
    return this;
  }
}

class _$DioModule extends _i395.DioModule {}

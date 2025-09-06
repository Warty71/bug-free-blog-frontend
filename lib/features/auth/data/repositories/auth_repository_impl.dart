import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/token_storage.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../models/auth_token_mapper.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/user_mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _apiService;
  final NetworkInfo _networkInfo;
  final TokenStorage _tokenStorage;

  const AuthRepositoryImpl(
    this._apiService,
    this._networkInfo,
    this._tokenStorage,
  );

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = await _apiService.register(
          RegisterRequest(name: name, email: email, password: password),
        );
        return Right(userModel.toEntity());
      } on DioException catch (e) {
        return Left(_handleDioException(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthToken>> login({
    required String email,
    required String password,
  }) async {
    if (await _networkInfo.isConnected) {
      try {
        final tokenModel = await _apiService.login(
          LoginRequest(email: email, password: password),
        );
        final token = tokenModel.toEntity();

        // Save token to storage
        await _tokenStorage.saveToken(token.accessToken);

        return Right(token);
      } on DioException catch (e) {
        return Left(_handleDioException(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await _networkInfo.isConnected) {
      try {
        final userModel = await _apiService.getCurrentUser();
        return Right(userModel.toEntity());
      } on DioException catch (e) {
        return Left(_handleDioException(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await _networkInfo.isConnected) {
      try {
        await _apiService.logout();
        // Clear token from storage
        await _tokenStorage.clearToken();
        return const Right(null);
      } on DioException catch (e) {
        return Left(_handleDioException(e));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        // Extract error message from response body
        String errorMessage = 'Server error: $statusCode';
        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('detail')) {
          errorMessage = responseData['detail'].toString();
        }

        if (statusCode == 401) {
          return ServerFailure(message: errorMessage);
        } else if (statusCode == 409) {
          return ServerFailure(message: errorMessage);
        } else if (statusCode == 422) {
          return ValidationFailure(message: errorMessage);
        } else {
          return ServerFailure(message: errorMessage);
        }
      case DioExceptionType.cancel:
        return const NetworkFailure(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'Connection error');
      default:
        return const NetworkFailure(message: 'Network error');
    }
  }
}

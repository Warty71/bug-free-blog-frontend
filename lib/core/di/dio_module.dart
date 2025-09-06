import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../network/token_storage.dart';

@module
abstract class DioModule {
  @Named('authDio')
  @singleton
  Dio get authDio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8000/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add debug interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print(' REQUEST: ${options.method} ${options.uri}');
          print(' HEADERS: ${options.headers}');
          print('📄 DATA: ${options.data}');
          handler.next(options);
        },
        onError: (error, handler) {
          print('❌ ERROR: ${error.response?.statusCode}');
          print('📄 ERROR DATA: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    return dio;
  }

  @Named('authenticatedDio')
  @singleton
  Dio get authenticatedDio {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8000/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add auth interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final tokenStorage = TokenStorage();
          final token = await tokenStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print(' REQUEST: ${options.method} ${options.uri}');
          print(' HEADERS: ${options.headers}');
          print('📄 DATA: ${options.data}');
          handler.next(options);
        },
        onError: (error, handler) {
          print('❌ ERROR: ${error.response?.statusCode}');
          print('📄 ERROR DATA: ${error.response?.data}');
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}

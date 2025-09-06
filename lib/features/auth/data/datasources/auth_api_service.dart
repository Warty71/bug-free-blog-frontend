import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';
import '../models/token_model.dart';
import '../models/user_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
@injectable
abstract class AuthApiService {
  @factoryMethod
  factory AuthApiService(@Named('authenticatedDio') Dio dio) = _AuthApiService;

  @POST('/auth/register')
  Future<UserModel> register(@Body() RegisterRequest request);

  @POST('/auth/login')
  Future<TokenModel> login(@Body() LoginRequest request);

  @GET('/auth/me')
  Future<UserModel> getCurrentUser();

  @POST('/auth/logout')
  Future<void> logout();
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthToken>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> logout();
}

import 'package:injectable/injectable.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  ResultFuture<AuthToken> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}

import 'package:injectable/injectable.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  ResultFuture<User> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _repository.register(name: name, email: email, password: password);
  }
}

import 'package:injectable/injectable.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  ResultFuture<User> call() {
    return _repository.getCurrentUser();
  }
}

import '../../domain/entities/user.dart';
import 'user_model.dart';

extension UserModelMapper on UserModel {
  User toEntity() {
    return User(id: id, name: name, email: email);
  }
}

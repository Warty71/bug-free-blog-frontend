import '../../domain/entities/auth_token.dart';
import 'token_model.dart';

extension TokenModelMapper on TokenModel {
  AuthToken toEntity() {
    return AuthToken(accessToken: accessToken, tokenType: tokenType);
  }
}

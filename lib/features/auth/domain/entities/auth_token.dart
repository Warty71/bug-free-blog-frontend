import 'package:equatable/equatable.dart';

class AuthToken extends Equatable {
  final String accessToken;
  final String tokenType;

  const AuthToken({required this.accessToken, this.tokenType = 'bearer'});

  @override
  List<Object> get props => [accessToken, tokenType];
}

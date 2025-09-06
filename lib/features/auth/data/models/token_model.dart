import 'package:json_annotation/json_annotation.dart';

part 'token_model.g.dart';

@JsonSerializable()
class TokenModel {
  @JsonKey(name: 'access_token')
  final String accessToken;
  @JsonKey(name: 'token_type')
  final String tokenType;

  const TokenModel({required this.accessToken, this.tokenType = 'bearer'});

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
}

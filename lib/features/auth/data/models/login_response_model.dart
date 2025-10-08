import '../../domain/entities/user_entity.dart';
import 'user_model.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']).toEntity(),
      accessToken: json['token'],
      refreshToken: json['refresh_token'],
    );
  }

  final UserEntity user;
  final String accessToken;
  final String? refreshToken;
}

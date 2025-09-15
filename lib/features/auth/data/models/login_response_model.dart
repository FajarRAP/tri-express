import 'user_model.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final UserModel user;
  final String accessToken;
  final String? refreshToken;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['token'],
      refreshToken: json['refresh_token'],
    );
  }
}

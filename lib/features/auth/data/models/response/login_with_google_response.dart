import '../user_model.dart';

class LoginWithGoogleResponse {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  LoginWithGoogleResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginWithGoogleResponse.fromJson(Map<String, dynamic> json) {
    return LoginWithGoogleResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(json['user']),
    );
  }
}

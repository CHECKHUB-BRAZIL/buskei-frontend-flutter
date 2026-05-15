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
    final userData = Map<String, dynamic>.from(json['user']);

    userData['token'] = json['access_token'];

    return LoginWithGoogleResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: UserModel.fromJson(userData),
    );
  }
}

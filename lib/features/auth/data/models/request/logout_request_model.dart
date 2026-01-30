class LogoutRequestModel {
  final String refreshToken;

  LogoutRequestModel({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }
}

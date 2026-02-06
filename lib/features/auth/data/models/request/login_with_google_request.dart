class LoginWithGoogleRequest {
  final String idToken;

  LoginWithGoogleRequest({required this.idToken});

  Map<String, dynamic> toJson() {
    return {
      'id_token': idToken,
    };
  }
}

class UserLoginResponse {
  final String token;
  final int userId;
  final String nome;

  UserLoginResponse({
    required this.token,
    required this.userId,
    required this.nome,
  });

  factory UserLoginResponse.fromJson(Map<String, dynamic> json){
    return UserLoginResponse(
      token: json['access_token'],
      userId: json['user_id'],
      nome: json['nome'],
    );
  }
}

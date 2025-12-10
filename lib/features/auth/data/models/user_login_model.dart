class UserLoginModel {
  final String email;
  final String senha;

  UserLoginModel({
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "senha": senha,
    };
  }
}

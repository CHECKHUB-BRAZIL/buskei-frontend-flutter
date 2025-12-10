class UserRegisterModel {
  final String email;
  final String senha;

  UserRegisterModel({
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

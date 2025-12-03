class UserRegister {
  final String nome;
  final String email;
  final String senha;

  UserRegister({
    required this.nome,
    required this.email,
    required this.senha,
  });

  Map<String, dynamic> toJson(){
    return {
      "nome": nome,
      "email": email,
      "senha": senha,
    };
  }
}

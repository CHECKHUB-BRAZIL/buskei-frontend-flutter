/// Modelo responsável por representar os dados enviados
/// ao backend ao realizar um login.
///
/// Este model pertence à camada *Data* e converte
/// dados da apresentação (email + senha) em JSON.
///
/// Ele é usado exclusivamente para requisições (request),
/// nunca para respostas.
class UserLoginRequestModel {
  /// Email informado pelo usuário na tela de login.
  final String email;

  /// Senha informada pelo usuário.
  final String senha;

  UserLoginRequestModel({
    required this.email,
    required this.senha,
  });

  /// Converte o model para JSON para envio ao backend.
  ///
  /// Exemplo do JSON produzido:
  /// ```json
  /// {
  ///   "email": "teste@gmail.com",
  ///   "senha": "123456"
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'senha': senha,
    };
  }
}

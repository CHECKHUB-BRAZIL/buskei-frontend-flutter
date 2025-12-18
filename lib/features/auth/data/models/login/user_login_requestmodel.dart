/// Modelo responsável por representar a **requisição de login**
/// enviada ao backend.
///
/// Este modelo vive apenas na camada **Data**, pois descreve a estrutura
/// exata que será enviada em formato JSON.
///
/// Ele NÃO deve conter lógica de negócio.
///
/// Seu papel é:
/// - Agrupar os dados necessários para o login
/// - Convertê-los para JSON
class LoginRequestModel {
  /// Email do usuário.
  final String email;

  /// Senha do usuário.
  final String senha;

  LoginRequestModel({
    required this.email,
    required this.senha,
  });

  /// Converte o modelo em JSON para enviar ao backend.
  ///
  /// Exemplo gerado:
  /// ```json
  /// {
  ///   "email": "joao@example.com",
  ///   "senha": "senha123"
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'senha': senha,
    };
  }
}

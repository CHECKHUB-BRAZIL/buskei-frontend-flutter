/// Modelo responsável por representar a **requisição de registro**
/// enviada ao backend.
///
/// Este model vive apenas na camada **Data**, pois descreve a estrutura
/// exata que será enviada em formato JSON.
///
/// Ele NÃO deve conter lógica de negócio.
///
/// Seu papel é:
/// - Agrupar os dados necessários para o registro
/// - Convertê-los para JSON
class RegisterRequestModel {
  /// Nome do usuário a ser cadastrado.
  final String nome;

  /// Email válido do usuário.
  final String email;

  /// Senha usada para criação da conta.
  final String senha;

  RegisterRequestModel({
    required this.nome,
    required this.email,
    required this.senha,
  });

  /// Converte o modelo em JSON para enviar ao backend.
  ///
  /// Exemplo gerado:
  /// ```json
  /// {
  ///   "nome": "João Silva",
  ///   "email": "joao@example.com",
  ///   "senha": "senha123"
  /// }
  /// ```
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'email': email,
      'senha': senha,
    };
  }
}

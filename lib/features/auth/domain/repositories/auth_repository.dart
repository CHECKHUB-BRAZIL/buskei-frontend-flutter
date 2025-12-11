import '../entities/user_entity.dart';

/// Interface (contrato) que define as operações de autenticação.
/// 
/// Dentro da arquitetura DDD, o [AuthRepository] pertence à *Domain Layer*
/// e representa uma **abstração** sobre qualquer fonte de dados
/// (API, banco local, etc). A implementação concreta será feita
/// na camada `data/`.
///
/// Ele garante que a camada de domínio nunca conheça detalhes
/// técnicos de acesso à rede ou persistência.
///
/// Métodos:
/// - [login]: autentica um usuário existente.
/// - [register]: registra um novo usuário.
///
/// Ambos retornam um [UserEntity], garantindo que apenas
/// entidades de domínio trafeguem entre as camadas.
abstract class AuthRepository {
  
  /// Realiza o login de um usuário existente.
  ///
  /// Retorna um [UserEntity] caso o login seja bem-sucedido.
  ///
  /// Parâmetros:
  /// - [email] Email do usuário.
  /// - [senha] Senha do usuário.
  ///
  /// Exceções:
  /// - Pode lançar erros de validação ou de autenticação vindos da camada
  ///   de dados, como usuário inexistente, senha incorreta, falha na API etc.
  Future<UserEntity> login({
    required String email,
    required String senha,
  });

  /// Registra um novo usuário no sistema.
  ///
  /// Retorna um [UserEntity] representando o usuário recém-criado.
  ///
  /// Parâmetros:
  /// - [nome] Nome do usuário.
  /// - [email] Email válido do usuário.
  /// - [senha] Senha definida.
  ///
  /// Exceções:
  /// - Pode lançar erros caso dados sejam inválidos ou a API retorne falhas.
  Future<UserEntity> register({
    required String nome,
    required String email,
    required String senha,
  });
}

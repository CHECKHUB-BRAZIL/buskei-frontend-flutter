import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
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
/// **Importante**: Todos os métodos retornam [Either<Failure, T>],
/// onde:
/// - [Left] = Falha (erro)
/// - [Right] = Sucesso
///
/// Isso evita uso de exceções e torna o tratamento de erros explícito.
abstract class AuthRepository {
  
  /// Realiza o login de um usuário existente.
  ///
  /// Retorna:
  /// - [Right(UserEntity)]: Login bem-sucedido com dados do usuário
  /// - [Left(Failure)]: Falha na autenticação
  ///
  /// Parâmetros:
  /// - [email]: Email do usuário
  /// - [senha]: Senha do usuário
  ///
  /// Possíveis falhas:
  /// - [ServerFailure]: Erro na API
  /// - [NetworkFailure]: Sem conexão
  /// - [ValidationFailure]: Dados inválidos
  /// - [AuthFailure]: Credenciais incorretas
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String senha,
  });

  /// Registra um novo usuário no sistema.
  ///
  /// Retorna:
  /// - [Right(UserEntity)]: Registro bem-sucedido
  /// - [Left(Failure)]: Falha no registro
  ///
  /// Parâmetros:
  /// - [nome]: Nome do usuário
  /// - [email]: Email válido do usuário
  /// - [senha]: Senha definida
  ///
  /// Possíveis falhas:
  /// - [ServerFailure]: Erro na API
  /// - [ValidationFailure]: Dados inválidos
  /// - [ConflictFailure]: Email já cadastrado
  Future<Either<Failure, UserEntity>> register({
    required String nome,
    required String email,
    required String senha,
  });

  /// Realiza o logout do usuário atual.
  ///
  /// Remove token e dados armazenados localmente.
  ///
  /// Retorna:
  /// - [Right(void)]: Logout bem-sucedido
  /// - [Left(Failure)]: Falha no logout
  Future<Either<Failure, void>> logout();

  /// Obtém o usuário atualmente autenticado.
  ///
  /// Verifica se há um token válido armazenado e retorna
  /// os dados do usuário correspondente.
  ///
  /// Retorna:
  /// - [Right(UserEntity)]: Usuário autenticado
  /// - [Left(Failure)]: Nenhum usuário autenticado ou token inválido
  Future<Either<Failure, UserEntity>> getCurrentUser();

  /// Verifica se há um usuário autenticado.
  ///
  /// Retorna [true] se houver token válido armazenado.
  Future<Either<Failure, bool>> isAuthenticated();

  /// Atualiza o token de acesso usando o refresh token.
  ///
  /// Retorna:
  /// - [Right(String)]: Novo token de acesso
  /// - [Left(Failure)]: Falha na atualização
  Future<Either<Failure, String>> refreshToken();

  /// Atualiza os dados do perfil do usuário.
  ///
  /// Parâmetros opcionais para atualização parcial.
  ///
  /// Retorna:
  /// - [Right(UserEntity)]: Usuário atualizado
  /// - [Left(Failure)]: Falha na atualização
  Future<Either<Failure, UserEntity>> updateProfile({
    String? nome,
    String? email,
  });

  /// Altera a senha do usuário.
  ///
  /// Retorna:
  /// - [Right(void)]: Senha alterada com sucesso
  /// - [Left(Failure)]: Falha na alteração
  Future<Either<Failure, void>> changePassword({
    required String senhaAtual,
    required String novaSenha,
  });

  
  Future<Either<Failure, UserEntity>> loginWithGoogle({
    required String idToken,
  });
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Use Case responsável por obter o usuário atualmente autenticado.
///
/// Este caso de uso verifica se há um token válido armazenado
/// e retorna os dados do usuário correspondente.
///
/// Retorna:
/// - [Right(UserEntity)]: Usuário autenticado encontrado
/// - [Left(Failure)]: Nenhum usuário autenticado ou token inválido
///
/// Casos de uso:
/// - Tela inicial do app (verificar se usuário está logado)
/// - Proteção de rotas
/// - Exibição de dados do perfil
class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

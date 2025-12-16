import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Use Case responsável por realizar o logout do usuário.
///
/// Este caso de uso:
/// - Remove o token de autenticação armazenado
/// - Limpa dados do usuário em cache
/// - Invalida a sessão atual
///
/// Retorna:
/// - [Right(void)]: Logout realizado com sucesso
/// - [Left(Failure)]: Falha ao realizar logout
///
/// Casos de uso:
/// - Botão de sair do app
/// - Logout automático após expiração de token
/// - Troca de conta
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}

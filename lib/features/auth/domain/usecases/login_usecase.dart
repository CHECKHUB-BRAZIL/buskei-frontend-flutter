import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Use Case responsável por realizar o login de um usuário.
///
/// Este caso de uso encapsula a lógica de autenticação,
/// validando credenciais e retornando dados do usuário autenticado.
///
/// Retorna:
/// - [Right(UserEntity)]: Login bem-sucedido
/// - [Left(Failure)]: Falha na autenticação
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    // Validações básicas podem ser feitas aqui
    if (params.email.isEmpty) {
      return const Left(ValidationFailure('Email não pode ser vazio'));
    }

    if (!params.email.contains('@')) {
      return const Left(ValidationFailure('Email inválido'));
    }

    if (params.senha.isEmpty) {
      return const Left(ValidationFailure('Senha não pode ser vazia'));
    }

    if (params.senha.length < 6) {
      return const Left(ValidationFailure('Senha deve ter no mínimo 6 caracteres'));
    }

    // Delega ao repository
    return await repository.login(
      email: params.email,
      senha: params.senha,
    );
  }
}

/// Parâmetros necessários para o LoginUseCase.
class LoginParams extends Equatable {
  final String email;
  final String senha;

  const LoginParams({
    required this.email,
    required this.senha,
  });

  @override
  List<Object> get props => [email, senha];
}

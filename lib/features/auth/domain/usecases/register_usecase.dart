import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Use Case responsável por registrar um novo usuário.
///
/// Este caso de uso encapsula a lógica de registro,
/// validando dados e criando uma nova conta no sistema.
///
/// Retorna:
/// - [Right(UserEntity)]: Registro bem-sucedido
/// - [Left(Failure)]: Falha no registro
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    // Validações básicas
    if (params.nome.isEmpty) {
      return const Left(ValidationFailure('Nome não pode ser vazio'));
    }

    if (params.nome.length < 2) {
      return const Left(ValidationFailure('Nome deve ter no mínimo 2 caracteres'));
    }

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

    // Validação adicional: senha e confirmação devem ser iguais
    if (params.confirmacaoSenha != null && 
        params.senha != params.confirmacaoSenha) {
      return const Left(ValidationFailure('Senhas não conferem'));
    }

    // Delega ao repository
    return await repository.register(
      nome: params.nome,
      email: params.email,
      senha: params.senha,
    );
  }
}

/// Parâmetros necessários para o RegisterUseCase.
class RegisterParams extends Equatable {
  final String nome;
  final String email;
  final String senha;
  final String? confirmacaoSenha;

  const RegisterParams({
    required this.nome,
    required this.email,
    required this.senha,
    this.confirmacaoSenha,
  });

  @override
  List<Object?> get props => [nome, email, senha, confirmacaoSenha];
}

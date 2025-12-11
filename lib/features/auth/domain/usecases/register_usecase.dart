import 'package:buskei/features/auth/domain/entities/user_entity.dart';
import 'package:buskei/features/auth/domain/repositories/auth_repository.dart';

import 'usecase.dart';
import 'register_params.dart';

/// Caso de uso responsável por registrar um novo usuário.
/// 
/// Recebe os dados de cadastro através de [RegisterParams]
/// e solicita ao repositório que crie o usuário no backend.
/// 
/// Aqui é o ponto ideal para validar regras de negócio, como:
/// - formato do e-mail
/// - tamanho mínimo da senha
/// - unicidade do nome/username (se aplicável)
/// 
/// Retorna um [UserEntity] ao finalizar o registro.
/// Em caso de erro, deve lançar exceções específicas tratadas
/// nas camadas superiores (apresentação ou infraestrutura).
class RegisterUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<UserEntity> call(RegisterParams params) async {
    final length = params.email.length;
    // Validações de domínio antes de chamar API
    if (params.nome.isEmpty) {
      throw Exception("Nome não pode ser vazio.");
    }

    if (params.email.isEmpty || !params.email.contains('@')) {
      throw Exception("Email inválido.");
    }

    if (length < 7 || length > 9) {
      throw Exception("A senha deve ter entre 7 e 9 caracteres.");
    }

    // Chama o repositório (que chama a API)
    final user = await repository.register(
      nome: params.nome,
      email: params.email,
      senha: params.senha,
    );

    // Regras de domínio pós-registro
    if (!user.canLogin()) {
      throw Exception("Usuário criado mas desativado.");
    }

    return user;
  }
}

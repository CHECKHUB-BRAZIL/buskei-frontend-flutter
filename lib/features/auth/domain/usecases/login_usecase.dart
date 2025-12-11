import 'package:buskei/features/auth/domain/entities/user_entity.dart';
import 'package:buskei/features/auth/domain/repositories/auth_repository.dart';
import 'usecase.dart';

/// Parâmetros necessários para executar o caso de uso de login.
/// 
/// Representa os dados usados para autenticar um usuário no sistema.
/// 
/// [email] E-mail cadastrado.
/// [senha] Senha correspondente ao e-mail informado.
class LoginParams {
  final String email;
  final String senha;

  LoginParams({
    required this.email,
    required this.senha,
  });
}

/// Caso de uso responsável por autenticar um usuário.
/// 
/// Esse caso de uso recebe as credenciais por meio de [LoginParams]
/// e delega ao repositório a tarefa de validar o usuário.
/// 
/// A lógica de autenticação (como validação, erros, filtros, etc.)
/// deve acontecer aqui quando necessário, mantendo a camada de domínio
/// isolada de detalhes de infraestrutura.
/// 
/// Retorna um [UserEntity] em caso de sucesso.
/// Pode lançar exceções específicas da aplicação caso o login falhe.

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<UserEntity> call(LoginParams params) async {
    // Validações de domínio
    if (params.email.isEmpty || !params.email.contains('@')) {
      throw Exception("Email inválido");
    }
    if (params.senha.isEmpty) {
      throw Exception("Senha não pode estar vazia");
    }

    // Aciona o repositório
    final user = await repository.login(
      email: params.email,
      senha: params.senha,
    );

    // Regras adicionais
    if (!user.canLogin()) {
      throw Exception("Usuário desativado");
    }

    return user;
  }
}

import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login/user_login_requestmodel.dart';
import '../models/register/user_register_requestmodel.dart';

/// Implementação concreta do [AuthRepository] usada pela camada de domínio.
///
/// Esta classe faz a ponte entre:
/// - Os *UseCases* (que chamam este repositório)
/// - O *DataSource remoto* (responsável por acessar a API)
///
/// Responsabilidades:
/// - Criar os *request models* com os dados vindos do domínio
/// - Delegar as chamadas ao [IAuthRemoteDataSource]
/// - Converter *response models* em entidades de domínio ([UserEntity])
///
/// A camada de domínio não sabe nada sobre JSON, HTTP ou modelos.
/// Todo esse trabalho fica concentrado nesta classe.
class AuthRepositoryImpl implements AuthRepository {
  /// Fonte de dados remota responsável por chamadas HTTP.
  final IAuthRemoteDataSource datasource;

  /// Construtor recebe a dependência já injetada.
  AuthRepositoryImpl(this.datasource);

  /// Executa o fluxo de login do usuário.
  ///
  /// Etapas:
  /// 1. Cria um [UserLoginRequestModel] com os dados recebidos do domínio.
  /// 2. Envia o modelo para o [datasource] executar a chamada HTTP.
  /// 3. Recebe um *response model* e converte para [UserEntity].
  ///
  /// Retorno:
  /// - Um [UserEntity] representando o usuário logado.
  ///
  /// Exceções:
  /// - Pode lançar erros vindos do `datasource`
  /// - Pode lançar erros das validações da entidade
  @override
  Future<UserEntity> login({
    required String email,
    required String senha,
  }) async {
    // 1. Monta o request model
    final request = UserLoginRequestModel(
      email: email,
      senha: senha,
    );

    // 2. Chama o datasource, que retorna um response model
    final response = await datasource.login(request);

    // 3. Converte o model para entidade
    return response.toEntity();
  }

  /// Executa o fluxo de registro de um novo usuário.
  ///
  /// Etapas:
  /// 1. Cria um [UserRegisterRequestModel] a partir dos dados recebidos.
  /// 2. Envia o modelo ao [datasource] para chamada HTTP.
  /// 3. Converte o [UserRegisterResponseModel] em [UserEntity].
  ///
  /// Retorno:
  /// - Um [UserEntity] representando o usuário recém-registrado.
  ///
  /// Exceções:
  /// - Pode lançar erros de rede ou respostas inválidas
  /// - Pode lançar erros de validação da entidade
  @override
  Future<UserEntity> register({
    required String nome,
    required String email,
    required String senha,
  }) async {
    // 1. Monta o request model
    final request = UserRegisterRequestModel(
      nome: nome,
      email: email,
      senha: senha,
    );

    // 2. Chama o datasource e recebe um response model
    final response = await datasource.register(request);

    // 3. Converte o response model para entidade
    return response.toEntity();
  }
}

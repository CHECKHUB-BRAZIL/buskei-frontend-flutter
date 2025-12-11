import '../../../domain/entities/user_entity.dart';

/// Modelo responsável por representar a **resposta do backend**
/// durante o processo de registro de um novo usuário.
///
/// Este modelo pertence exclusivamente à camada **Data**, onde lidamos
/// com formatos JSON, detalhes da API e estruturas específicas
/// de comunicação com o backend.
///
/// Ele NÃO deve conter regras de negócio.
/// Seu único papel é:
/// - Receber JSON da API (Response)
/// - Converter esse JSON em uma entidade do domínio (UserEntity)
class UserRegisterResponseModel {
  /// Identificador único gerado pelo backend para o novo usuário.
  final String id;

  /// Nome do usuário retornado na resposta do backend.
  final String nome;

  /// Email do usuário cadastrado.
  final String email;

  /// Token JWT ou outro tipo de token retornado pelo backend
  /// após o registro.
  ///
  /// Este valor **não deve ser enviado para o domínio**.
  /// Ele é usado apenas na camada de infraestrutura
  /// para autenticação das próximas requisições.
  final String token;

  UserRegisterResponseModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.token,
  });

  /// Constrói um [UserRegisterResponseModel] a partir de um JSON.
  ///
  /// Exemplo esperado:
  /// ```json
  /// {
  ///   "id": "123",
  ///   "nome": "Sophia",
  ///   "email": "sophia@gmail.com",
  ///   "token": "jwt123abc"
  /// }
  /// ```
  factory UserRegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterResponseModel(
      id: json["id"] as String,
      nome: json["nome"] as String,
      email: json["email"] as String,
      token: json["token"] as String,
    );
  }

  /// Converte o response model em uma entidade de domínio [UserEntity].
  ///
  /// Apenas os dados essenciais à regra de negócio são repassados.
  /// O token é descartado, pois faz parte da camada Data/Infra.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nome: nome,
      email: email,
    );
  }
}

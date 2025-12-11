import '../../domain/entities/user_entity.dart';

/// Modelo responsável por representar a resposta do backend
/// após uma tentativa de login.
///
/// Ele pertence à camada *Data*, lidando APENAS com transformação
/// de dados (JSON → Model → Entity).
class UserLoginResponseModel {
  /// Identificador único do usuário retornado pelo backend.
  final String id;

  /// Nome do usuário retornado pela API.
  final String nome;

  /// Email do usuário.
  final String email;

  /// Token de autenticação retornado pelo backend.
  final String token;

  UserLoginResponseModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.token,
  });

  /// Constrói o model a partir de um JSON vindo da API.
  factory UserLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return UserLoginResponseModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
      token: json['token'] as String,
    );
  }

  /// Converte o model para a entidade de domínio [UserEntity].
  ///
  /// Tokens NÃO vão para o domínio – apenas dados essenciais.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      nome: nome,
      email: email,
    );
  }
}

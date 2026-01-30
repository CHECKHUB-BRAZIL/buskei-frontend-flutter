import '../user_model.dart';

/// Modelo responsável por representar a **resposta do backend**
/// durante o processo de registro de um novo usuário.
///
/// Pertence à camada **Data** e lida exclusivamente com JSON/API.
class RegisterResponseModel {
  /// Dados do usuário recém-criado.
  final UserModel user;

  /// Token de acesso JWT.
  final String accessToken;

  /// Token de refresh (opcional).
  final String? refreshToken;

  /// Tipo do token (default: Bearer).
  final String tokenType;

  /// Mensagem opcional do backend.
  final String? message;

  RegisterResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.message,
  });

  /// Constrói um [RegisterResponseModel] a partir do JSON real do backend.
  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      message: json['message'] as String?,
    );
  }

  /// Converte para JSON (cache / debug).
  Map<String, dynamic> toJson() {
    return {
      ...user.toJson(),
      'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      'token_type': tokenType,
      if (message != null) 'message': message,
    };
  }
}

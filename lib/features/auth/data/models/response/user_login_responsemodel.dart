import '../user_model.dart';

/// Modelo responsável por representar a **resposta do backend**
/// durante o processo de login.
///
/// Este modelo pertence exclusivamente à camada **Data**, onde lidamos
/// com formatos JSON, detalhes da API e estruturas específicas
/// de comunicação com o backend.
///
/// Ele NÃO deve conter regras de negócio.
/// Seu único papel é:
/// - Receber JSON da API (Response)
/// - Converter esse JSON em um [UserModel]
class LoginResponseModel {
  /// Dados do usuário retornados pelo backend.
  final UserModel user;

  /// Token de acesso JWT para autenticação.
  final String accessToken;

  /// Token de refresh para renovar o accessToken (opcional).
  final String? refreshToken;

  /// Tipo do token (geralmente "Bearer").
  final String tokenType;

  /// Tempo de expiração do token em segundos (opcional).
  final int? expiresIn;

  LoginResponseModel({
    required this.user,
    required this.accessToken,
    this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
  });

  /// Constrói um [LoginResponseModel] a partir de um JSON.
  ///
  /// Exemplo esperado:
  /// ```json
  /// {
  ///   "user": {
  ///     "id": "123",
  ///     "nome": "João Silva",
  ///     "email": "joao@example.com",
  ///     "is_active": true
  ///   },
  ///   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  ///   "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  ///   "token_type": "Bearer",
  ///   "expires_in": 3600
  /// }
  /// ```
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // Adiciona o token ao user model
    final userData = Map<String, dynamic>.from(json['user'] as Map);
    userData['token'] = json['access_token'];

    return LoginResponseModel(
      user: UserModel.fromJson(userData),
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String? ?? 'Bearer',
      expiresIn: json['expires_in'] as int?,
    );
  }

  /// Converte para JSON (útil para cache/log)
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      'token_type': tokenType,
      if (expiresIn != null) 'expires_in': expiresIn,
    };
  }
}

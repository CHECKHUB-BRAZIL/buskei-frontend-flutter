/// Classe responsável por centralizar todas as configurações da API.
///
/// Objetivos:
/// - Evitar URLs e endpoints “hardcoded” espalhados pelo código
/// - Facilitar manutenção e mudança de ambientes (dev, staging, produção)
/// - Centralizar timeouts e configurações de rede
///
/// Esta classe é usada principalmente por:
/// - Camada de Data (datasources remotos)
/// - Configuração do Dio ou outro client HTTP
class ApiConfig {
  // ---------------------------------------------------------------------------
  // Base URL
  // ---------------------------------------------------------------------------

  /// URL base da API.
  ///
  /// Utiliza variáveis de ambiente quando disponíveis (recomendado para produção).
  ///
  /// Exemplo de build com variável:
  /// flutter run --dart-define=API_BASE_URL=https://api.meuapp.com/api/v1
  ///
  /// Caso a variável não seja informada, utiliza o valor padrão
  /// (útil para desenvolvimento local).
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );

  // ---------------------------------------------------------------------------
  // Endpoints de autenticação
  // ---------------------------------------------------------------------------

  /// Endpoint para login de usuário
  static const String loginEndpoint = '/auth/login';

  /// Endpoint para registro de novo usuário
  static const String registerEndpoint = '/auth/register';

  /// Endpoint para logout do usuário autenticado
  static const String logoutEndpoint = '/auth/logout';

  /// Endpoint para renovação do token de acesso (refresh token)
  static const String refreshTokenEndpoint = '/auth/refresh';

  /// Endpoint para obter os dados do usuário autenticado
  static const String currentUserEndpoint = '/auth/me';

  // ---------------------------------------------------------------------------
  // Configurações de timeout
  // ---------------------------------------------------------------------------

  /// Tempo máximo para estabelecer conexão com o servidor
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Tempo máximo de espera pela resposta do servidor
  static const Duration receiveTimeout = Duration(seconds: 30);
}

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Cliente HTTP centralizado da aplicação.
///
/// Responsabilidades:
/// - Configurar o Dio com baseUrl, timeouts e headers padrão
/// - Injetar automaticamente o token de autenticação nas requisições
/// - Centralizar interceptors (auth, refresh token, logs, etc)
/// - Evitar repetição de configuração do Dio em múltiplos datasources
///
/// Deve ser instanciado uma única vez (singleton) via injeção de dependência.
class ApiClient {
  /// Instância interna do Dio utilizada para chamadas HTTP
  final Dio _dio;

  /// Armazenamento seguro para leitura do token de autenticação
  final FlutterSecureStorage _storage;

  /// Cria uma nova instância do [ApiClient].
  ///
  /// Parâmetros:
  /// - [baseUrl]: URL base da API
  /// - [storage]: armazenamento seguro usado para recuperar tokens
  ///
  /// Configura:
  /// - Timeouts de conexão e resposta
  /// - Headers padrão da API
  /// - Interceptors globais
  ApiClient({
    required String baseUrl,
    required FlutterSecureStorage storage,
  })  : _storage = storage,
        _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
    _setupInterceptors();
  }

  /// Configura os interceptors globais do Dio.
  ///
  /// Atualmente:
  /// - Adiciona automaticamente o token Bearer em cada requisição
  /// - Intercepta respostas 401 para futura implementação de refresh token
  ///
  /// Sugestão:
  /// - Extrair interceptors para classes separadas (AuthInterceptor, LoggerInterceptor)
  /// - Manter este método apenas como orquestrador
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        /// Interceptor executado antes de cada requisição.
        ///
        /// - Recupera o token salvo no storage
        /// - Injeta o header Authorization se o token existir
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

        /// Interceptor executado quando ocorre um erro na requisição.
        ///
        /// - Detecta erro 401 (não autorizado)
        /// - Local ideal para implementar refresh token
        ///
        /// ⚠️ Importante:
        /// Evite loops infinitos de refresh. Controle tentativas.
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // TODO: Implementar lógica de refresh token
            // await _refreshToken();
          }

          handler.next(error);
        },
      ),
    );
  }

  /// Exposição controlada da instância do Dio.
  ///
  /// Deve ser usada pelos datasources remotos da aplicação.
  Dio get dio => _dio;
}

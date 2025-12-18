import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Interceptor responsável por gerenciar autenticação nas requisições HTTP.
///
/// Funções principais:
/// - Adicionar automaticamente o token de acesso (JWT) no header `Authorization`
/// - Centralizar a lógica de autenticação do client HTTP
/// - Evitar repetição de código em cada chamada de API
/// - Servir como ponto único para implementar refresh token futuramente
///
/// Este interceptor deve ser registrado no Dio durante a configuração
/// do client HTTP.
///
/// Exemplo de uso:
/// ```dart
/// dio.interceptors.add(
///   AuthInterceptor(storage: secureStorage),
/// );
/// ```
class AuthInterceptor extends Interceptor {
  /// Armazenamento seguro onde o token de acesso é persistido.
  ///
  /// Normalmente gerenciado pelo datasource local de autenticação.
  final FlutterSecureStorage storage;

  /// Cria uma instância do [AuthInterceptor].
  ///
  /// Recebe uma instância de [FlutterSecureStorage] para permitir
  /// a leitura do token de acesso de forma segura.
  AuthInterceptor({required this.storage});

  /// Intercepta todas as requisições antes de serem enviadas.
  ///
  /// Caso exista um token salvo, ele é automaticamente adicionado
  /// ao header `Authorization` no formato:
  ///
  /// Authorization: Bearer <token>
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Recupera o token de acesso armazenado
    final token = await storage.read(key: 'access_token');

    // Adiciona o token no header, se existir
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continua o fluxo da requisição
    super.onRequest(options, handler);
  }

  /// Intercepta erros retornados pela API.
  ///
  /// Atualmente:
  /// - Apenas repassa o erro adiante
  ///
  /// Futuro:
  /// - Pode ser usada para implementar refresh token automático
  ///   quando o backend retornar HTTP 401 (Unauthorized)
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Se receber 401, o token pode estar expirado
    if (err.response?.statusCode == 401) {
      // TODO:
      // - Tentar renovar o token usando refresh token
      // - Repetir a requisição original
      // - Fazer logout caso o refresh falhe
    }

    // Continua o tratamento padrão do erro
    super.onError(err, handler);
  }
}

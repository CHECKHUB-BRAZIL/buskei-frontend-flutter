import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor responsável por realizar logs detalhados das requisições HTTP.
///
/// Características:
/// - Loga requisições, respostas e erros
/// - Executa apenas em modo debug (`kDebugMode`)
/// - Auxilia no debug e desenvolvimento
/// - Não deve ser utilizado em produção (release)
///
/// Este interceptor deve ser adicionado ao Dio somente em ambientes
/// de desenvolvimento.
///
/// Exemplo de uso:
/// ```dart
/// dio.interceptors.add(LoggerInterceptor());
/// ```
class LoggerInterceptor extends Interceptor {
  /// Intercepta todas as requisições antes de serem enviadas.
  ///
  /// Exibe no console:
  /// - Método HTTP
  /// - Caminho da requisição
  /// - Headers
  /// - Corpo (body) da requisição
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('REQUEST [${options.method}]');
      debugPrint('PATH: ${options.path}');
      debugPrint('HEADERS: ${options.headers}');
      debugPrint('BODY: ${options.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    // Continua o fluxo normal da requisição
    super.onRequest(options, handler);
  }

  /// Intercepta todas as respostas recebidas com sucesso.
  ///
  /// Exibe no console:
  /// - Código de status HTTP
  /// - Caminho da requisição
  /// - Corpo da resposta
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('RESPONSE [${response.statusCode}]');
      debugPrint('PATH: ${response.requestOptions.path}');
      debugPrint('BODY: ${response.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    // Continua o fluxo normal da resposta
    super.onResponse(response, handler);
  }

  /// Intercepta erros retornados pela API ou falhas de rede.
  ///
  /// Exibe no console:
  /// - Código de status HTTP (se existir)
  /// - Caminho da requisição
  /// - Mensagem de erro
  /// - Corpo da resposta de erro (se existir)
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      debugPrint('ERROR [${err.response?.statusCode}]');
      debugPrint('PATH: ${err.requestOptions.path}');
      debugPrint('MESSAGE: ${err.message}');
      debugPrint('BODY: ${err.response?.data}');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }

    // Continua o fluxo padrão de erro
    super.onError(err, handler);
  }
}

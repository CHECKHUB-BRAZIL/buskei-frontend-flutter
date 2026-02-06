import 'package:buskei/core/network/api_client.dart';
import 'package:buskei/features/auth/data/models/request/logout_request_model.dart';
import 'package:buskei/features/auth/data/models/response/login_with_google_response.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/config/api_config.dart';
import '../models/request/user_login_requestmodel.dart';
import '../models/response/user_login_responsemodel.dart';
import '../models/request/user_register_requestmodel.dart';
import '../models/response/user_register_responsemodel.dart';
import '../models/user_model.dart';

/// Contrato que define as operações remotas de autenticação.
///
/// Esta interface pertence à **camada de Data** e representa
/// a comunicação com fontes externas (API, backend, etc).
///
/// ### Objetivos desta abstração
/// - Desacoplar o repositório da implementação HTTP
/// - Permitir troca de cliente (Dio, http, mock, fake)
/// - Facilitar testes unitários e de integração
/// - Centralizar o contrato de comunicação com a API
///
/// ⚠️ Esta camada:
/// - **Pode lançar exceções**
/// - **Não conhece entidades de domínio**
/// - **Trabalha apenas com models**
abstract class AuthRemoteDataSource {
  /// Realiza o login do usuário no backend.
  ///
  /// Envia as credenciais para a API e retorna:
  /// - Dados do usuário autenticado
  /// - Token de acesso
  /// - Token de refresh (se aplicável)
  ///
  /// Lança:
  /// - [AuthException] para credenciais inválidas
  /// - [NetworkException] para erros de conexão
  /// - [ServerException] para erros inesperados da API
  Future<LoginResponseModel> login(LoginRequestModel request);

  /// Registra um novo usuário no backend.
  ///
  /// Retorna os dados do usuário criado e tokens de autenticação.
  ///
  /// Lança:
  /// - [ValidationException] para dados inválidos
  /// - [NetworkException] para falhas de conexão
  /// - [ServerException] para erros inesperados
  Future<RegisterResponseModel> register(RegisterRequestModel request);

  /// Obtém os dados do usuário atualmente autenticado.
  ///
  /// Requer um token de acesso válido, geralmente enviado
  /// via interceptor no header `Authorization`.
  ///
  /// Lança:
  /// - [AuthException] se o token estiver inválido ou expirado
  /// - [NetworkException] para erros de conexão
  /// - [ServerException] para erros da API
  Future<UserModel> getCurrentUser();

  /// Solicita um novo token de acesso usando o refresh token.
  ///
  /// Retorna um novo `access_token`.
  ///
  /// Lança:
  /// - [AuthException] se o refresh token for inválido
  /// - [NetworkException] para erros de conexão
  /// - [ServerException] para erros da API
  Future<String> refreshToken(String refreshToken);

  /// Realiza logout no backend.
  ///
  /// Dependendo da API, esta operação pode:
  /// - Invalidar tokens
  /// - Encerrar sessões
  ///
  /// ⚠️ O logout local deve ser feito independentemente
  /// do sucesso desta chamada.
  ///
  /// Lança:
  /// - [NetworkException]
  /// - [ServerException]
  Future<void> logout(String refreshToken);

  Future<LoginWithGoogleResponse> loginWithGoogle({
    required String idToken,
  });
}

/// Implementação concreta de [AuthRemoteDataSource] utilizando **Dio**.
///
/// Responsabilidades:
/// - Executar chamadas HTTP para a API
/// - Converter respostas JSON em models
/// - Traduzir erros do Dio em exceções de domínio da camada Data
///
/// ⚠️ Esta classe:
/// - **Não trata UI**
/// - **Não retorna Either**
/// - **Lança exceções para o repositório tratar**
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// Cliente HTTP configurado com interceptors, baseUrl, headers, etc.
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await apiClient.dio.post(
        ApiConfig.loginEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      }

      throw ServerException(
        'Erro ao fazer login: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await apiClient.dio.post(
        ApiConfig.registerEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(response.data);
      }

      throw ServerException(
        'Erro ao registrar usuário: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.dio.get(ApiConfig.currentUserEndpoint);

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }

      throw ServerException(
        'Erro ao buscar usuário atual: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    try {
      final response = await apiClient.dio.post(
        ApiConfig.refreshTokenEndpoint,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return response.data['access_token'] as String;
      }

      throw ServerException(
        'Erro ao renovar token: ${response.statusCode}',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> logout(String refreshToken) async {
    try {
      final request = LogoutRequestModel(refreshToken: refreshToken);

      final response = await apiClient.dio.post(
        ApiConfig.logoutEndpoint,
        data: request.toJson(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          'Erro ao fazer logout: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Converte erros do [DioException] em exceções específicas da aplicação.
  ///
  /// Centraliza a interpretação de erros HTTP, permitindo:
  /// - Mensagens mais amigáveis
  /// - Padronização do tratamento de falhas
  /// - Facilidade de manutenção
  ///
  /// Esta função **não retorna null** e sempre gera
  /// uma exceção significativa para o repositório.
  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Tempo de conexão esgotado');

      case DioExceptionType.connectionError:
        return NetworkException(
          'Erro de conexão. Verifique sua internet.',
        );

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message =
            e.response?.data?['message'] ?? e.response?.data?['detail'];

        if (statusCode == 401) {
          return AuthException(message ?? 'Credenciais inválidas');
        }

        if (statusCode == 409) {
          return ValidationException(message ?? 'Email já cadastrado');
        }

        if (statusCode == 422) {
          return ValidationException(message ?? 'Dados inválidos');
        }

        return ServerException(
          message ?? 'Erro no servidor',
          statusCode: statusCode,
        );

      default:
        return ServerException('Erro inesperado: ${e.message}');
    }
  }

  @override
  Future<LoginWithGoogleResponse> loginWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/google-login',
        data: {
          'id_token': idToken,
        },
      );

      if (response.statusCode == 200) {
        return LoginWithGoogleResponse.fromJson(response.data);
      }

      throw ServerException(
        'Erro ao autenticar com Google',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }
}

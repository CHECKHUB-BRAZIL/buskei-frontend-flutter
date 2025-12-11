import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_login_requestmodel.dart';
import '../models/user_login_responsemodel.dart';
import '../models/user_register_requestmodel.dart';
import '../models/user_register_responsemodel.dart';

/// ------------------------------------------------------------
/// Interface da fonte de dados remota de autenticação.
///
/// Esta interface define os contratos que qualquer implementação
/// remota deve seguir (HTTP, Firebase, Supabase, etc).
///
/// Camadas que dependem de autenticação trabalham SOMENTE com esta
/// interface, nunca com a implementação concreta.
/// ------------------------------------------------------------
abstract class IAuthRemoteDataSource {

  /// Realiza uma requisição de login utilizando um [UserLoginRequestModel].
  ///
  /// Retorna um [UserLoginResponseModel] contendo os dados do usuário
  /// e o token JWT retornado pelo backend.
  Future<UserLoginResponseModel> login(UserLoginRequestModel model);

  /// Realiza uma requisição de registro (criação de conta).
  ///
  /// Recebe um [UserRegisterRequestModel] contendo nome, email e senha,
  /// e retorna um [UserRegisterResponseModel] com os dados criados pelo backend.
  Future<UserRegisterResponseModel> register(UserRegisterRequestModel model);
}

/// ------------------------------------------------------------
/// Implementação HTTP da fonte de dados remota de autenticação.
///
/// Esta classe é responsável por fazer chamadas REST para a API.
/// Ela converte models → JSON e JSON → models, sem regras de negócio.
/// ------------------------------------------------------------
class AuthRemoteDataSource implements IAuthRemoteDataSource {
  /// URL base da API (ex: https://meu-servidor.com/api)
  final String baseUrl;

  AuthRemoteDataSource(this.baseUrl);

  /// Envia uma requisição POST para /login contendo email e senha.
  ///
  /// Em caso de sucesso (status 200), retorna um [UserLoginResponseModel].
  /// Se a API retornar erro, lança uma [Exception].
  @override
  Future<UserLoginResponseModel> login(UserLoginRequestModel model) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Erro ao fazer login: ${response.body}");
    }

    final json = jsonDecode(response.body);
    return UserLoginResponseModel.fromJson(json);
  }

  /// Envia uma requisição POST para /register contendo nome, email e senha.
  ///
  /// Em caso de sucesso (status 201), retorna um [UserRegisterResponseModel].
  /// Em caso de erro, lança uma [Exception] com a mensagem retornada pela API.
  @override
  Future<UserRegisterResponseModel> register(UserRegisterRequestModel model) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception("Erro ao registrar: ${response.body}");
    }

    final json = jsonDecode(response.body);
    return UserRegisterResponseModel.fromJson(json);
  }
}

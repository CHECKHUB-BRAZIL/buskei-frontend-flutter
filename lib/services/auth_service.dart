import 'package:buskei/models/user_login.dart';
import 'package:buskei/models/user_register.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<UserLoginResponse> login(String email, String senha) async {
    try {
      final url = Uri.parse("$baseUrl/login");

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": email.trim(),
              "senha": senha.trim(),
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return UserLoginResponse.fromJson(jsonDecode(response.body));
      }

      if (response.statusCode == 401) {
        throw Exception("Email ou senha inválidos");
      }

      throw Exception("Erro ao fazer login (${response.statusCode})");
    } on SocketException {
      throw Exception("Sem conexão com a internet");
    } on HttpException {
      throw Exception("Erro de comunicação com o servidor");
    } on FormatException {
      throw Exception("Resposta inválida do servidor");
    }
  }

  Future<void> register(UserRegister data) async {
    try {
      final url = Uri.parse("$baseUrl/register");

      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(data.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) return;

      if (response.statusCode == 409) {
        throw Exception("Usuário já existe");
      }

      throw Exception("Erro ao criar conta (${response.statusCode})");
    } on SocketException {
      throw Exception("Sem conexão com a internet");
    } on HttpException {
      throw Exception("Erro de comunicação com o servidor");
    } on FormatException {
      throw Exception("Resposta inválida do servidor");
    }
  }
}

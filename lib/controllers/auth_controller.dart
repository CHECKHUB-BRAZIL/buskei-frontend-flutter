import 'package:buskei/services/auth_service.dart';
import 'package:buskei/models/user_register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final AuthService authService = AuthService("https://sua-api.com");

  bool loading = false;
  String? token;

  Future<bool> login(String email, String senha) async {
    try {
      loading = true;
      notifyListeners();

      final user = await authService.login(email, senha);

      token = user.token;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token!);

      loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      loading = false;
      notifyListeners();

      debugPrint("Erro no login: $e");
      return false;
    }
  }

  Future<bool> register(String nome, String email, String senha) async {
    try {
      loading = true;
      notifyListeners();

      final userData = UserRegister(
        nome: nome,
        email: email,
        senha: senha,
      );

      await authService.register(userData);

      loading = false;
      notifyListeners();

      return true;
    } catch (e) {
      loading = false;
      notifyListeners();

      debugPrint("Erro no cadastro: $e");
      return false;
    }
  }
}

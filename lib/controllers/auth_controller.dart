import 'package:buskei/services/auth_service.dart';
import 'package:buskei/models/user_register.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier{
  final authService = AuthService();
  bool loading = false;
  String? token;

  Future<bool> login(String email, String senha) async {
    loading = true;
    notifyListeners();

    final result = await authService.login(email, senha);

    loading = false;
    notifyListeners();

    if(result == null) {
      return false;
    }

    token = result.token;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token!);

    return true;
  }

  Future<bool> register(String nome, String email, String senha) async {
    loading = true;

    final data = UserRegister(
      nome: nome,
      email: email,
      senha: senha,
    );

    final result = await authService.register(data);

    loading = false;
    return result;
  }
}

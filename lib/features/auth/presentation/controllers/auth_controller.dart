import 'package:flutter/material.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/entities/user_entity.dart';

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  bool isLoading = false;
  UserEntity? user;

  Future<bool> login(String email, String senha) async {
    try {
      isLoading = true;
      notifyListeners();

      user = await loginUseCase(email, senha);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register(String email, String senha) async {
    try {
      await registerUseCase(email, senha);
      return true;
    } catch (e) {
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthController extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  bool isLoading = false;
  String? errorMessage;

  AuthController({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  // ---------------------------
  // Login
  // ---------------------------
  Future<bool> login({
    required String email,
    required String senha,
  }) async {
    return _handleAuthAction(() async {
      await loginUseCase(
        LoginParams(
          email: email,
          senha: senha,
        ),
      );
    });
  }

  // ---------------------------
  // Register
  // ---------------------------
  Future<bool> register({
    required String nome,
    required String email,
    required String senha,
  }) async {
    return _handleAuthAction(() async {
      await registerUseCase(
        RegisterParams(
          nome: nome,
          email: email,
          senha: senha,
        ),
      );
    });
  }

  // ---------------------------
  // Private generic handler
  // ---------------------------
  Future<bool> _handleAuthAction(Future<void> Function() action) async {
    try {
      errorMessage = null;
      isLoading = true;
      notifyListeners();

      await action();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
// import '../features/home/presentation/pages/home_page.dart'; // Quando criar

/// Centraliza a definição de todas as rotas da aplicação.
///
/// Responsável por:
/// - Definir nomes de rotas como constantes
/// - Registrar páginas no GetX
/// - Padronizar transições entre telas
///
/// Evita:
/// - Strings mágicas espalhadas pelo código
/// - Duplicação de configuração de navegação
class AppRoutes {
  // ---------------------------------------------------------------------------
  // Nomes das rotas
  // ---------------------------------------------------------------------------

  /// Rota inicial da aplicação (Splash)
  static const String splash = '/';

  /// Rota da tela de login
  static const String login = '/login';

  /// Rota da tela de cadastro
  static const String register = '/register';

  // ---------------------------------------------------------------------------
  // Lista de rotas registradas no GetX
  // ---------------------------------------------------------------------------

  /// Lista de páginas utilizadas pelo [GetMaterialApp].
  ///
  /// Cada [GetPage] define:
  /// - O nome da rota
  /// - O widget da página
  /// - A transição de navegação
  /// - (Opcional) middlewares e bindings específicos
  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}

/// Middleware responsável por proteger rotas autenticadas.
///
/// O [AuthMiddleware] permite:
/// - Interceptar a navegação antes da página ser exibida
/// - Redirecionar usuários não autenticados
/// - Centralizar a lógica de proteção de rotas
///
/// Pode ser usado diretamente em um [GetPage]:
///
/// ```dart
/// GetPage(
///   name: AppRoutes.home,
///   page: () => const HomePage(),
///   middlewares: [AuthMiddleware()],
/// )
/// ```
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // -------------------------------------------------------------------------
    // Lógica de autenticação (a implementar)
    // -------------------------------------------------------------------------

    // Exemplo de implementação futura:
    //
    // final authController = Get.find<AuthController>();
    //
    // if (!authController.isAuthenticated.value) {
    //   return const RouteSettings(name: AppRoutes.login);
    // }

    /// Retornar `null` permite a navegação normalmente
    return null;
  }
}

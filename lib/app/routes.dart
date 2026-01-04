import 'package:buskei/core/middleware/auth_middleware.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import '../features/auth/presentation/bindings/auth_binding.dart';

import '../features/home/presentation/pages/home_page.dart';
import '../features/home/presentation/bindings/home_binding.dart';

class AppRoutes {
  // ---------------------------------------------------------------------------
  // Nomes das rotas
  // ---------------------------------------------------------------------------

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  // ---------------------------------------------------------------------------
  // Rotas do GetX
  // ---------------------------------------------------------------------------

  static final routes = [
    GetPage(
      name: splash,
      page: () => const SplashPage(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: login,
      page: () => const LoginPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: register,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: home,
      page: () => const HomePage(),
      bindings: [
        AuthBinding(),
        HomeBinding(),
      ],
      transition: Transition.fadeIn,
      middlewares: [AuthMiddleware()],
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  
  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      // Rotas protegidas
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
        redirect: (context, state) {
          // Verificar autenticação
          // final isAuthenticated = ...
          // if (!isAuthenticated) return AppRoutes.login;
          return null;
        },
      ),
    ],
  );
}

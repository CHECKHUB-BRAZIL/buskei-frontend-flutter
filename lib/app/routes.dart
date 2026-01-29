import 'package:buskei/core/middleware/auth_middleware.dart';
import 'package:get/get.dart';

import '../features/app_shell/presentation/pages/splash_page.dart';
import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/register_page.dart';
import 'auth_binding.dart';

import '../features/app_shell/presentation/pages/app_shell_page.dart';
import '../features/app_shell/presentation/bindings/app_shell_binding.dart';

class AppRoutes {
  // ---------------------------------------------------------------------------
  // Route names
  // ---------------------------------------------------------------------------

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String appShell = '/app';

  // ---------------------------------------------------------------------------
  // GetX routes
  // ---------------------------------------------------------------------------

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

    GetPage(
      name: appShell,
      page: () => const AppShellPage(),
      bindings: [
        AppShellBinding(),
      ],
      middlewares: [AuthMiddleware()],
      transition: Transition.fadeIn,
    ),
  ];
}

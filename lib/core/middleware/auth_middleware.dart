import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../app/routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthenticated.value) {
      return const RouteSettings(name: AppRoutes.login);
    }

    return null;
  }
}

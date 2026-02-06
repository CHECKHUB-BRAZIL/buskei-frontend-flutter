import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    if (!auth.isUserAuthenticated()) {
      return const RouteSettings(name: '/login');
    }

    return null;
  }
}

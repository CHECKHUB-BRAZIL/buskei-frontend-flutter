import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/app_shell_controller.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';

class AppShellPage extends GetView<AppShellController> {
  const AppShellPage({super.key});

  AuthController get authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Buscar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBody() {
    switch (controller.currentIndex.value) {
      case 0:
        return const HomePage();
      case 1:
        return const SearchPage();
      case 2:
        return ProfilePage(authController: authController);
      default:
        return const SizedBox.shrink();
    }
  }
}

import 'package:buskei/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

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

  // ---------------------------------------------------------------------------
  // BODY
  // ---------------------------------------------------------------------------

  Widget _buildBody() {
    switch (controller.currentIndex.value) {
      case 0:
        return _buildScreen('Home');
      case 1:
        return _buildScreen('Buscar');
      case 2:
        return _buildProfile(); // 👈 AQUI
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------------
  // TELAS SIMPLES
  // ---------------------------------------------------------------------------

  Widget _buildScreen(String title) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0057FF),
      child: Center(
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PERFIL + LOGOUT
  // ---------------------------------------------------------------------------

  Widget _buildProfile() {

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF0057FF),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Perfil',
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: authController.isLoading.value
                  ? null
                  : () async {
                      await authController.logout();
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0057FF),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: Obx(() {
                return authController.isLoading.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Sair');
              }),
            ),
          ],
        ),
      ),
    );
  }
}

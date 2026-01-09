import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController;

  const ProfilePage({super.key, required this.authController});

  @override
  Widget build(BuildContext context) {
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
            Obx(() {
              return ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : () async {
                        await authController.logout();
                      },
                child: authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Sair'),
              );
            }),
          ],
        ),
      ),
    );
  }
}

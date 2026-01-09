import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_overlay.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perfil',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Obx(
        () => LoadingOverlay(
          isLoading: authController.isLoading.value,
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final user = authController.currentUser.value;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          /// Avatar + nome
          ProfileHeader(
            name: user?.nome ?? 'Usuário',
            email: user?.email ?? '',
          ),

          const SizedBox(height: 32),

          /// Card com infos
          ProfileInfoCard(
            createdAt: user?.createdAt,
            isActive: user?.isActive ?? false,
          ),

          const Spacer(),

          /// Logout
          CustomButton(
            text: 'Sair da conta',
            icon: Icons.logout,
            isLoading: authController.isLoading.value,
            onPressed: () async {
              await authController.logout();
            },
          ),
        ],
      ),
    );
  }
}

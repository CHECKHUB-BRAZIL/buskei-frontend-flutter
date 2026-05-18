import 'package:buskei/features/auth/presentation/controllers/auth_controller.dart';
import 'package:buskei/features/home/infrastructure/models/analyze_link_response_model.dart';
import 'package:buskei/features/home/infrastructure/services/api_service.dart';
import 'package:buskei/features/home/presentation/widgets/link_result_card.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LinkCheckerSection extends StatefulWidget {
  const LinkCheckerSection({super.key});

  @override
  State<LinkCheckerSection> createState() => _LinkCheckerSectionState();
}

class _LinkCheckerSectionState extends State<LinkCheckerSection> {
  final TextEditingController _controller = TextEditingController();

  AnalyzeLinkResponseModel? analysis;

  bool isLoading = false;

  Future<void> checkLink() async {
    final text = _controller.text.trim();

    if (text.isEmpty) return;

    final auth = Get.find<AuthController>();

    final token = auth.currentUser.value?.token;

    // =========================================================
    // VALIDA AUTENTICAÇÃO
    // =========================================================

    if (token == null || token.isEmpty) {
      setState(() {
        analysis = AnalyzeLinkResponseModel(
          url: text,
          risk: "HIGH",
          riskScore: 100,
          reasons: [
            "Usuário não autenticado",
          ],
          positives: [],
        );
      });

      return;
    }

    setState(() {
      isLoading = true;
      analysis = null;
    });

    try {
      ApiService.setToken(token);

      final response = await ApiService.analyzeLink(text);

      setState(() {
        analysis = response;
      });
    } catch (e) {
      setState(() {
        analysis = AnalyzeLinkResponseModel(
          url: text,
          risk: "HIGH",
          riskScore: 100,
          reasons: [
            "Erro de conexão com o servidor",
          ],
          positives: [],
        );
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================================================
        // TÍTULO
        // =========================================================

        Row(
          children: [
            const Icon(
              Icons.link,
              color: Colors.blue,
              size: 20,
            ),

            const SizedBox(width: 6),

            Text(
              "Verificar link",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // =========================================================
        // INPUT
        // =========================================================

        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Cole o link aqui...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // =========================================================
        // BOTÃO
        // =========================================================

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : checkLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0057FF),
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "Verificar link",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // =========================================================
        // RESULTADO
        // =========================================================

        if (analysis != null)
          LinkResultCard(
            result: analysis!,
          ),
      ],
    );
  }
}

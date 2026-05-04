import 'package:buskei/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'result_card.dart';

class BoletoSection extends StatefulWidget {
  const BoletoSection({super.key});

  @override
  State<BoletoSection> createState() => _BoletoSectionState();
}

class _BoletoSectionState extends State<BoletoSection> {
  final TextEditingController _controller = TextEditingController();

  String? result;
  List<String> reasons = [];
  bool isLoading = false;

  void _analyzeBoleto(String linha) {
    if (linha.isEmpty) return;

    final auth = Get.find<AuthController>();
    final token = auth.currentUser.value?.token;

    // Validação de autenticação
    if (token == null || token.isEmpty) {
      setState(() {
        result = "HIGH";
        reasons = ["Usuário não autenticado"];
      });
      return;
    }

    setState(() {
      isLoading = true;
      result = null;
      reasons = [];
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;

        // Regras simuladas
        if (linha.length < 40) {
          result = "HIGH";
          reasons = [
            "A linha digitável é muito curta e não segue o padrão esperado.",
            "Boletos válidos geralmente possuem 47 ou 48 dígitos.",
          ];
        } else if (!RegExp(r'^\d+$').hasMatch(linha)) {
          result = "HIGH";
          reasons = [
            "A linha digitável contém caracteres inválidos.",
            "Boletos devem conter apenas números.",
          ];
        } else if (linha.startsWith("000")) {
          result = "MEDIUM";
          reasons = [
            "O código do banco parece incomum ou desconhecido.",
            "Verifique se o banco emissor é confiável.",
          ];
        } else {
          result = "LOW";
          reasons = [
            "A estrutura da linha digitável parece válida.",
            "Nenhum problema evidente foi identificado.",
            "Mesmo assim, confirme o beneficiário antes de pagar.",
          ];
        }
      });
    });
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
        // TÍTULO
        Row(
          children: [
            const Icon(Icons.receipt, color: Colors.orange, size: 20),
            const SizedBox(width: 6),
            Text(
              "Verificar boleto",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // INPUT
        TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Cole a linha digitável do boleto...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // BOTÃO
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () => _analyzeBoleto(_controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 14),
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
                    "Verificar boleto",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // RESULTADO
        if (result != null)
          ResultCard(
            result: result!,
            reasons: reasons,
          ),
      ],
    );
  }
}

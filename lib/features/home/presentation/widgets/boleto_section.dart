import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';

import '../../infrastructure/models/boleto_validation_response_model.dart';
import '../../infrastructure/services/api_service.dart';

import 'boleto_result_card.dart';

class BoletoSection extends StatefulWidget {
  const BoletoSection({super.key});

  @override
  State<BoletoSection> createState() => _BoletoSectionState();
}

class _BoletoSectionState extends State<BoletoSection> {
  final TextEditingController _controller = TextEditingController();

  BoletoValidationResponseModel? boletoResult;

  bool isLoading = false;

  String? errorMessage;

  Future<void> _analyzeBoleto(String code) async {
    if (code.isEmpty) return;

    final cleanedCode = code.replaceAll(
      RegExp(r'\D'),
      '',
    );

    // valida tamanho
    if (cleanedCode.length < 44 ||
        cleanedCode.length > 48) {
      setState(() {
        errorMessage =
            "O boleto deve conter entre 44 e 48 dígitos.";
      });

      return;
    }

    final auth = Get.find<AuthController>();

    final token = auth.currentUser.value?.token;

    // Usuário não autenticado
    if (token == null || token.isEmpty) {
      setState(() {
        errorMessage = "Usuário não autenticado";
      });

      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
      boletoResult = null;
    });

    try {
      ApiService.setToken(token);

      final response = await ApiService.validateBoleto(
        cleanedCode,
      );

      setState(() {
        boletoResult = response;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
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
        // TÍTULO
        Row(
          children: [
            const Icon(
              Icons.receipt,
              color: Colors.orange,
              size: 20,
            ),

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

          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,

            LengthLimitingTextInputFormatter(48),
          ],

          decoration: InputDecoration(
            hintText:
                "Cole a linha digitável do boleto...",

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
                : () => _analyzeBoleto(
                      _controller.text.trim(),
                    ),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,

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
                    "Verificar boleto",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // ERRO
        if (errorMessage != null)
          Container(
            width: double.infinity,

            padding: const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.red.shade50,

              borderRadius: BorderRadius.circular(16),
            ),

            child: Text(
              errorMessage!,

              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // RESULTADO
        if (boletoResult != null)
          BoletoResultCard(
            result: boletoResult!,
          ),
      ],
    );
  }
}

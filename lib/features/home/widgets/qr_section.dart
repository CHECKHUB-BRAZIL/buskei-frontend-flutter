import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'result_card.dart';

class QRSection extends StatefulWidget {
  const QRSection({super.key});

  @override
  State<QRSection> createState() => _QRSectionState();
}

class _QRSectionState extends State<QRSection> {
  final TextEditingController _controller = TextEditingController();

  String? result;
  List<String> reasons = [];
  bool isLoading = false;

  void _analyzeQR(String content) {
    if (content.isEmpty) return;

    setState(() {
      isLoading = true;
      result = null;
      reasons = [];
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;

        // Regras simuladas
        if (content.contains("http")) {
          result = "MEDIUM";
          reasons = [
            "O QR Code contém um link, o que pode redirecionar para um site externo.",
            "Sempre verifique a origem antes de abrir links desconhecidos.",
          ];
        } else if (content.length < 10) {
          result = "HIGH";
          reasons = [
            "Conteúdo muito curto ou inválido.",
            "Pode ser um QR Code malicioso ou corrompido.",
          ];
        } else {
          result = "LOW";
          reasons = [
            "Nenhum comportamento suspeito foi identificado.",
            "O conteúdo parece seguro para uso.",
          ];
        }
      });
    });
  }

  void _openCamera() {
    setState(() {
      result = "MEDIUM";
      reasons = [
        "A leitura de câmera ainda não está integrada.",
        "Por enquanto, cole o conteúdo manualmente abaixo.",
      ];
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
            const Icon(Icons.qr_code, color: Colors.purple, size: 20),
            const SizedBox(width: 6),
            Text(
              "Escanear QR Code",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // BOTÃO CÂMERA
        OutlinedButton.icon(
          onPressed: _openCamera,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text("Abrir câmera"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.purple,
            side: const BorderSide(color: Colors.purple),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // INPUT
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Ou cole o conteúdo do QR Code...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // BOTÃO ANALISAR
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () => _analyzeQR(_controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
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
                    "Analisar QR Code",
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

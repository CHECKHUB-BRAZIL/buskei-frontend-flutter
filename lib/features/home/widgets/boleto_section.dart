import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

    setState(() {
      isLoading = true;
      result = "Analisando...";
      reasons = [];
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;

        // Regras simuladas
        if (linha.length < 40) {
          result = "🔴 Alto risco";
          reasons = [
            "A linha digitável é muito curta e não segue o padrão esperado.",
            "Boletos válidos geralmente possuem 47 ou 48 dígitos.",
          ];
        } else if (!RegExp(r'^\d+$').hasMatch(linha)) {
          result = "🔴 Alto risco";
          reasons = [
            "A linha digitável contém caracteres inválidos.",
            "Boletos devem conter apenas números.",
          ];
        } else if (linha.startsWith("000")) {
          result = "🟡 Atenção";
          reasons = [
            "O código do banco parece incomum ou desconhecido.",
            "Verifique se o banco emissor é confiável.",
          ];
        } else {
          result = "🟢 Seguro";
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
        if (result != null) _buildResultCard(),
      ],
    );
  }

  Widget _buildResultCard() {
    Color bgColor;
    Color textColor;

    if (result!.contains("🔴")) {
      bgColor = Colors.red.shade50;
      textColor = Colors.red;
    } else if (result!.contains("🟡")) {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange;
    } else {
      bgColor = Colors.green.shade50;
      textColor = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            result!,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          ...reasons.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "• $r",
                style: GoogleFonts.inter(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

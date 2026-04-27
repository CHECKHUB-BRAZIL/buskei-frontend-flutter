import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class LinkCheckerSection extends StatefulWidget {
  const LinkCheckerSection({super.key});

  @override
  State<LinkCheckerSection> createState() => _LinkCheckerSectionState();
}

class _LinkCheckerSectionState extends State<LinkCheckerSection> {
  final TextEditingController _controller = TextEditingController();

  String? result;
  List<String> reasons = [];
  bool isLoading = false;

  // Troque pelo seu token real
  final String token = "SEU_TOKEN_AQUI";

  Future<void> checkLink() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isLoading = true;
      result = "Analisando...";
      reasons = [];
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/v1/links/analyze'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"url": text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String risk = data['risk'];
        List<dynamic> apiReasons = data['reasons'];

        setState(() {
          result = _mapRisk(risk);
          reasons = apiReasons.map((e) => e.toString()).toList();
        });
      } else {
        setState(() {
          result = "Erro ao analisar";
          reasons = ["Servidor retornou erro (${response.statusCode})"];
        });
      }
    } catch (e) {
      setState(() {
        result = "Erro de conexão";
        reasons = ["Não foi possível conectar ao servidor"];
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _mapRisk(String risk) {
    switch (risk) {
      case "HIGH":
        return "🔴 Alto risco";
      case "MEDIUM":
        return "🟡 Atenção";
      case "LOW":
        return "🟢 Seguro";
      default:
        return "⚪ Desconhecido";
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
            const Icon(Icons.link, color: Colors.blue, size: 20),
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

        // INPUT
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

        // BOTÃO
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : checkLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0057FF),
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
                    "Verificar link",
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
          ...reasons.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  "• $r",
                  style: GoogleFonts.inter(fontSize: 13),
                ),
              )),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:buskei/features/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'result_card.dart';

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

  Future<void> checkLink() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final auth = Get.find<AuthController>();
    final token = auth.currentUser.value?.token;

    // 🔴 Validação de autenticação
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

        setState(() {
          result = data['risk']; // 👈 agora usa direto HIGH/MEDIUM/LOW
          reasons =
              (data['reasons'] as List).map((e) => e.toString()).toList();
        });
      } else {
        setState(() {
          result = "HIGH";
          reasons = ["Erro do servidor (${response.statusCode})"];
        });
      }
    } catch (e) {
      setState(() {
        result = "HIGH";
        reasons = ["Erro de conexão com o servidor"];
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
        if (result != null)
          ResultCard(
            result: result!,
            reasons: reasons,
          ),
      ],
    );
  }
}

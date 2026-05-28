import 'package:buskei/features/auth/presentation/controllers/auth_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/models/qrcode_response_model.dart';
import '../../infrastructure/services/api_service.dart';
import '../pages/qrcode_scanner_page.dart';

import 'qrcode_result_card.dart';

class QRSection extends StatefulWidget {
  const QRSection({super.key});

  @override
  State<QRSection> createState() =>
      _QRSectionState();
}

class _QRSectionState
    extends State<QRSection> {
  final TextEditingController _controller =
      TextEditingController();

  QRCodeResponseModel? qrResult;

  bool isLoading = false;

  String? errorMessage;

  Future<void> _analyzeQR(
    String content,
  ) async {
    if (content.isEmpty) return;

    final auth = Get.find<AuthController>();

    final token =
        auth.currentUser.value?.token;

    // =====================================================
    // USUÁRIO NÃO AUTENTICADO
    // =====================================================

    if (token == null || token.isEmpty) {
      setState(() {
        errorMessage =
            "Usuário não autenticado";
      });

      return;
    }

    setState(() {
      isLoading = true;

      errorMessage = null;

      qrResult = null;
    });

    try {
      ApiService.setToken(token);

      final response =
          await ApiService.validateQRCode(
        content,
      );

      setState(() {
        qrResult = response;
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

  Future<void> _openCamera() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const QRCodeScannerPage(),
      ),
    );

    if (result != null &&
        result is String) {
      _controller.text = result;

      await _analyzeQR(result);
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
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // =====================================================
        // TÍTULO
        // =====================================================

        Row(
          children: [
            const Icon(
              Icons.qr_code,
              color: Colors.purple,
              size: 20,
            ),

            const SizedBox(width: 6),

            Text(
              "Escanear QR Code",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // =====================================================
        // BOTÃO CÂMERA
        // =====================================================

        SizedBox(
          width: double.infinity,

          child: OutlinedButton.icon(
            onPressed: _openCamera,

            icon: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 22,
            ),

            label: Text(
              "Escanear QR Code",
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.purple,

              backgroundColor: Colors.purple.shade50,

              side: BorderSide(
                color: Colors.purple.shade200,
                width: 1.5,
              ),

              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 18,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // =====================================================
        // INPUT
        // =====================================================

        TextField(
          controller: _controller,

          decoration: InputDecoration(
            hintText:
                "Cole o conteúdo do QR Code...",

            filled: true,

            fillColor: Colors.white,

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              borderSide:
                  BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // =====================================================
        // BOTÃO ANALISAR
        // =====================================================

        SizedBox(
          width: double.infinity,

          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () => _analyzeQR(
                      _controller.text
                          .trim(),
                    ),

            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.purple,

              padding:
                  const EdgeInsets.symmetric(
                vertical: 14,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
            ),

            child: isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    "Analisar QR Code",
                    style:
                        GoogleFonts.inter(
                      fontWeight:
                          FontWeight.w600,

                      color: Colors.white,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // =====================================================
        // ERRO
        // =====================================================

        if (errorMessage != null)
          Container(
            width: double.infinity,

            padding:
                const EdgeInsets.all(16),

            decoration: BoxDecoration(
              color: Colors.red.shade50,

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),

            child: Text(
              errorMessage!,

              style: GoogleFonts.inter(
                color: Colors.red,

                fontWeight:
                    FontWeight.w500,
              ),
            ),
          ),

        // =====================================================
        // RESULTADO
        // =====================================================

        if (qrResult != null)
          QRCodeResultCard(
            result: qrResult!,
          ),
      ],
    );
  }
}

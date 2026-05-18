import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/boleto_section.dart';
import '../widgets/link_checker_section.dart';
import '../widgets/qr_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0057FF),

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // HEADER
            // =====================================================

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 28,
              ),
              child: Column(
                children: [
                  Text(
                    'Busquei',
                    style: GoogleFonts.inter(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Evite golpes verificando links, QR Codes e boletos.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      height: 1.4,
                      color: Colors.white.withOpacity(0.92),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // CONTEÚDO
            // =====================================================

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F6FA),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),

                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: const [
                    // =================================================
                    // LINK
                    // =================================================

                    LinkCheckerSection(),

                    SizedBox(height: 32),

                    // =================================================
                    // QR CODE
                    // =================================================

                    QRSection(),

                    SizedBox(height: 32),

                    // =================================================
                    // BOLETO
                    // =================================================

                    BoletoSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

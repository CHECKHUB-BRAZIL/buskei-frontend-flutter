import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/models/analyze_link_response_model.dart';

class LinkResultCard extends StatelessWidget {
  final AnalyzeLinkResponseModel result;

  const LinkResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final _RiskVisual visual = _getRiskVisual(result.risk);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: visual.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: visual.borderColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // HEADER
          // =========================================================

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: visual.iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  visual.icon,
                  color: visual.iconColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      visual.title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: visual.textColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Pontuação de risco: ${result.riskScore}/100',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // =========================================================
          // URL
          // =========================================================

          const SizedBox(height: 20),

          Text(
            'URL analisada',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              result.url,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),

          // =========================================================
          // POSITIVOS
          // =========================================================

          if (result.positives.isNotEmpty) ...[
            const SizedBox(height: 20),

            Text(
              'Indicadores positivos',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.green.shade800,
              ),
            ),

            const SizedBox(height: 10),

            ...result.positives.map(
              (positive) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        positive,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // =========================================================
          // ALERTAS
          // =========================================================

          if (result.reasons.isNotEmpty) ...[
            const SizedBox(height: 20),

            Text(
              'Alertas encontrados',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.red.shade800,
              ),
            ),

            const SizedBox(height: 10),

            ...result.reasons.map(
              (reason) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red.shade700,
                      size: 18,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        reason,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  _RiskVisual _getRiskVisual(String risk) {
    switch (risk.toUpperCase()) {
      case 'HIGH':
        return _RiskVisual(
          title: 'Link suspeito',
          backgroundColor: Colors.red.shade50,
          borderColor: Colors.red.shade200,
          iconBackgroundColor: Colors.red.shade100,
          iconColor: Colors.red.shade700,
          textColor: Colors.red.shade900,
          icon: Icons.gpp_bad,
        );

      case 'MEDIUM':
        return _RiskVisual(
          title: 'Link requer atenção',
          backgroundColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade200,
          iconBackgroundColor: Colors.orange.shade100,
          iconColor: Colors.orange.shade700,
          textColor: Colors.orange.shade900,
          icon: Icons.warning_amber_rounded,
        );

      default:
        return _RiskVisual(
          title: 'Link parece seguro',
          backgroundColor: Colors.green.shade50,
          borderColor: Colors.green.shade200,
          iconBackgroundColor: Colors.green.shade100,
          iconColor: Colors.green.shade700,
          textColor: Colors.green.shade900,
          icon: Icons.verified,
        );
    }
  }
}

class _RiskVisual {
  final String title;

  final Color backgroundColor;
  final Color borderColor;

  final Color iconBackgroundColor;
  final Color iconColor;

  final Color textColor;

  final IconData icon;

  _RiskVisual({
    required this.title,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });
}

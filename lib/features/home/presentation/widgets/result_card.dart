import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultCard extends StatelessWidget {
  final String result;
  final List<String> reasons;

  const ResultCard({
    super.key,
    required this.result,
    required this.reasons,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;

    if (result.contains("HIGH")) {
      bgColor = Colors.red.shade50;
      textColor = Colors.red;
      icon = Icons.warning;
    } else if (result.contains("MEDIUM")) {
      bgColor = Colors.orange.shade50;
      textColor = Colors.orange;
      icon = Icons.error_outline;
    } else {
      bgColor = Colors.green.shade50;
      textColor = Colors.green;
      icon = Icons.check_circle;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // RESULTADO PRINCIPAL
          Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
              Text(
                result,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // LISTA DE MOTIVOS
          ...reasons.map(
            (reason) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "• ",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      reason,
                      style: GoogleFonts.inter(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/models/boleto_validation_response_model.dart';

class BoletoResultCard extends StatelessWidget {
  final BoletoValidationResponseModel result;

  const BoletoResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final _BoletoVisual visual = _getVisual(result.status);

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
          // =====================================================
          // HEADER
          // =====================================================

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

          const SizedBox(height: 20),

          // =====================================================
          // INFORMAÇÕES
          // =====================================================

          _InfoTile(
            icon: Icons.attach_money,
            label: 'Valor',
            value: result.amountFormatted,
          ),

          const SizedBox(height: 12),

          _InfoTile(
            icon: Icons.calendar_today,
            label: 'Vencimento',
            value: result.dueDateFormatted,
          ),

          const SizedBox(height: 12),

          _InfoTile(
            icon: result.isExpired
                ? Icons.warning_amber_rounded
                : Icons.check_circle,
            label: 'Situação',
            value: result.isExpired
                ? 'Boleto vencido'
                : 'Dentro do prazo',
            valueColor: result.isExpired
                ? Colors.red.shade700
                : Colors.green.shade700,
          ),

          const SizedBox(height: 12),

          _InfoTile(
            icon: result.isReal
                ? Icons.verified
                : Icons.gpp_bad,
            label: 'Autenticidade',
            value: result.isReal
                ? 'Estrutura válida'
                : 'Estrutura inválida',
            valueColor: result.isReal
                ? Colors.green.shade700
                : Colors.red.shade700,
          ),

          // =====================================================
          // ALERTAS
          // =====================================================

          if (result.reasons.isNotEmpty) ...[
            const SizedBox(height: 24),

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

  _BoletoVisual _getVisual(String status) {
    switch (status.toLowerCase()) {
      case 'fraud_suspect':
        return _BoletoVisual(
          title: 'Boleto suspeito',
          backgroundColor: Colors.red.shade50,
          borderColor: Colors.red.shade200,
          iconBackgroundColor: Colors.red.shade100,
          iconColor: Colors.red.shade700,
          textColor: Colors.red.shade900,
          icon: Icons.gpp_bad,
        );

      case 'suspicious':
        return _BoletoVisual(
          title: 'Boleto requer atenção',
          backgroundColor: Colors.orange.shade50,
          borderColor: Colors.orange.shade200,
          iconBackgroundColor: Colors.orange.shade100,
          iconColor: Colors.orange.shade700,
          textColor: Colors.orange.shade900,
          icon: Icons.warning_amber_rounded,
        );

      default:
        return _BoletoVisual(
          title: 'Boleto parece válido',
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

class _InfoTile extends StatelessWidget {
  final IconData icon;

  final String label;

  final String value;

  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.black54,
        ),

        const SizedBox(width: 10),

        Text(
          '$label:',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _BoletoVisual {
  final String title;

  final Color backgroundColor;
  final Color borderColor;

  final Color iconBackgroundColor;
  final Color iconColor;

  final Color textColor;

  final IconData icon;

  _BoletoVisual({
    required this.title,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/models/qrcode_response_model.dart';

class QRCodeResultCard extends StatelessWidget {
  final QRCodeResponseModel result;

  const QRCodeResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final QRCodeVisual visual = _getVisual(
      result.status,
    );

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
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // =====================================================
          // HEADER
          // =====================================================

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      visual.iconBackgroundColor,
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
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      visual.title,
                      style:
                          GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            visual.textColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Pontuação de risco: ${result.riskScore}/100',
                      style:
                          GoogleFonts.inter(
                        fontSize: 13,
                        color:
                            Colors.black87,
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
            icon: Icons.qr_code,
            label: 'Tipo',
            value: result.qrcodeType,
          ),

          const SizedBox(height: 12),

          _InfoTile(
            icon: result.isValid
                ? Icons.verified
                : Icons.gpp_bad,
            label: 'Validação',
            value: result.isValid
                ? 'QRCode válido'
                : 'QRCode suspeito',
            valueColor: result.isValid
                ? Colors.green.shade700
                : Colors.red.shade700,
          ),

          const SizedBox(height: 12),

          _InfoTile(
            icon: Icons.text_fields,
            label: 'Conteúdo',
            value: result.rawValue,
          ),

          // =====================================================
          // PIX
          // =====================================================

          if (result.pixKey != null) ...[
            const SizedBox(height: 12),

            _InfoTile(
              icon: Icons.pix,
              label: 'Chave PIX',
              value: result.pixKey!,
            ),
          ],

          if (result.merchantName != null) ...[
            const SizedBox(height: 12),

            _InfoTile(
              icon: Icons.store,
              label: 'Recebedor',
              value: result.merchantName!,
            ),
          ],

          if (result.amount != null) ...[
            const SizedBox(height: 12),

            _InfoTile(
              icon: Icons.attach_money,
              label: 'Valor',
              value: result.amount!,
            ),
          ],

          // =====================================================
          // URL
          // =====================================================

          if (result.detectedUrl != null) ...[
            const SizedBox(height: 12),

            _InfoTile(
              icon: Icons.link,
              label: 'URL',
              value: result.detectedUrl!,
              valueColor:
                  result.isSuspiciousUrl
                      ? Colors.red.shade700
                      : Colors.blue.shade700,
            ),
          ],

          if (result.hasUnknownDomain) ...[
            const SizedBox(height: 12),

            _InfoTile(
              icon: Icons.warning,
              label: 'Domínio',
              value:
                  'Domínio desconhecido',
              valueColor:
                  Colors.orange.shade700,
            ),
          ],

          // =====================================================
          // ALERTAS
          // =====================================================

          if (result.reason != null &&
              result.reason!.isNotEmpty) ...[
            const SizedBox(height: 24),

            Text(
              'Alertas encontrados',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight:
                    FontWeight.w700,
                color:
                    Colors.red.shade800,
              ),
            ),

            const SizedBox(height: 10),

            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons
                      .warning_amber_rounded,
                  color:
                      Colors.red.shade700,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    result.reason!,
                    style:
                        GoogleFonts.inter(
                      fontSize: 14,
                      color:
                          Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  QRCodeVisual _getVisual(
    String status,
  ) {
    final normalizedStatus = status
        .trim()
        .toLowerCase();

    if (normalizedStatus ==
            'malicious' ||
        result.riskScore >= 80) {
      return QRCodeVisual(
        title: 'QRCode perigoso',
        backgroundColor:
            Colors.red.shade50,
        borderColor:
            Colors.red.shade200,
        iconBackgroundColor:
            Colors.red.shade100,
        iconColor:
            Colors.red.shade700,
        textColor:
            Colors.red.shade900,
        icon: Icons.gpp_bad,
      );
    }

    if (normalizedStatus ==
            'suspicious' ||
        result.riskScore >= 40) {
      return QRCodeVisual(
        title:
            'QRCode requer atenção',
        backgroundColor:
            Colors.orange.shade50,
        borderColor:
            Colors.orange.shade200,
        iconBackgroundColor:
            Colors.orange.shade100,
        iconColor:
            Colors.orange.shade700,
        textColor:
            Colors.orange.shade900,
        icon:
            Icons.warning_amber_rounded,
      );
    }

    return QRCodeVisual(
      title: 'QRCode seguro',
      backgroundColor:
          Colors.green.shade50,
      borderColor:
          Colors.green.shade200,
      iconBackgroundColor:
          Colors.green.shade100,
      iconColor:
          Colors.green.shade700,
      textColor:
          Colors.green.shade900,
      icon: Icons.verified,
    );
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
      crossAxisAlignment:
          CrossAxisAlignment.start,
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
              color:
                  valueColor ??
                  Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class QRCodeVisual {
  final String title;

  final Color backgroundColor;

  final Color borderColor;

  final Color iconBackgroundColor;

  final Color iconColor;

  final Color textColor;

  final IconData icon;

  QRCodeVisual({
    required this.title,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });
}

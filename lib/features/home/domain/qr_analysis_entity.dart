class QRAnalysisEntity {
  final String rawValue;

  final String qrcodeType;

  final bool isValid;

  final int riskScore;

  final String status;

  final List<String> reasons;

  final List<String> positives;

  // PIX
  final String? pixKey;

  final String? merchantName;

  final String? city;

  final double? amount;

  final String? txid;

  final bool? isValidCrc;

  // URL
  final String? detectedUrl;

  final bool isSuspiciousUrl;

  final bool hasUnknownDomain;

  const QRAnalysisEntity({
    required this.rawValue,
    required this.qrcodeType,
    required this.isValid,
    required this.riskScore,
    required this.status,
    required this.reasons,
    required this.positives,
    this.pixKey,
    this.merchantName,
    this.city,
    this.amount,
    this.txid,
    this.isValidCrc,
    this.detectedUrl,
    required this.isSuspiciousUrl,
    required this.hasUnknownDomain,
  });

  bool get hasRisk => riskScore > 0;

  bool get isSafe => status == 'safe';

  bool get isAttention => status == 'attention';

  bool get isSuspicious => status == 'suspicious';

  bool get isFraudSuspect =>
      status == 'fraud_suspect';

  bool get isPix =>
      qrcodeType.toLowerCase() == 'pix';

  bool get isUrl =>
      qrcodeType.toLowerCase() == 'url';
}

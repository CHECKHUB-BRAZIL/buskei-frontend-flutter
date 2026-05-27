class QRCodeResponseModel {
  final String rawValue;

  final String qrcodeType;

  final bool isValid;

  final int riskScore;

  final String status;

  final String? reason;

  final String? pixKey;

  final String? merchantName;

  final String? amount;

  final String? detectedUrl;

  final bool isSuspiciousUrl;

  final bool hasUnknownDomain;

  QRCodeResponseModel({
    required this.rawValue,
    required this.qrcodeType,
    required this.isValid,
    required this.riskScore,
    required this.status,
    this.reason,
    this.pixKey,
    this.merchantName,
    this.amount,
    this.detectedUrl,
    required this.isSuspiciousUrl,
    required this.hasUnknownDomain,
  });

  factory QRCodeResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return QRCodeResponseModel(
      rawValue:
          json['raw_value'] ?? '',

      qrcodeType:
          json['qrcode_type'] ?? '',

      isValid:
          json['is_valid'] ?? false,

      riskScore:
          json['risk_score'] ?? 0,

      status:
          json['status'] ?? 'unknown',

      reason:
          json['reason'],

      pixKey:
          json['pix_key'],

      merchantName:
          json['merchant_name'],

      amount:
          json['amount']?.toString(),

      detectedUrl:
          json['detected_url'],

      isSuspiciousUrl:
          json['is_suspicious_url'] ??
              false,

      hasUnknownDomain:
          json['has_unknown_domain'] ??
              false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raw_value': rawValue,
      'qrcode_type': qrcodeType,
      'is_valid': isValid,
      'risk_score': riskScore,
      'status': status,
      'reason': reason,
      'pix_key': pixKey,
      'merchant_name': merchantName,
      'amount': amount,
      'detected_url': detectedUrl,
      'is_suspicious_url':
          isSuspiciousUrl,
      'has_unknown_domain':
          hasUnknownDomain,
    };
  }
}

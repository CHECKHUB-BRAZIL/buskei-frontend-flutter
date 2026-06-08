class QRCodeResponseModel {
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

  QRCodeResponseModel({
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

      reasons:
          List<String>.from(
            json['reasons'] ?? [],
          ),

      positives:
          List<String>.from(
            json['positives'] ?? [],
          ),

      pixKey:
          json['pix_key'],

      merchantName:
          json['merchant_name'],

      city:
          json['city'],

      amount:
          json['amount'] != null
              ? double.tryParse(
                  json['amount'].toString(),
                )
              : null,

      txid:
          json['txid'],

      isValidCrc:
          json['is_valid_crc'],

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
      'reasons': reasons,
      'positives': positives,
      'pix_key': pixKey,
      'merchant_name': merchantName,
      'city': city,
      'amount': amount,
      'txid': txid,
      'is_valid_crc': isValidCrc,
      'detected_url': detectedUrl,
      'is_suspicious_url':
          isSuspiciousUrl,
      'has_unknown_domain':
          hasUnknownDomain,
    };
  }
}

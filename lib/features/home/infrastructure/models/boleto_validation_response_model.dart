class BoletoValidationResponseModel {
  // identificação
  final String code;
  final String originalCode;
  final String boletoType;

  // integridade
  final bool isReal;

  // financeiro
  final double amount;
  final String amountFormatted;

  // vencimento
  final DateTime? dueDate;
  final String dueDateFormatted;

  final bool isExpired;
  final int daysOverdue;
  final int? daysUntilDue;

  // antifraude
  final int riskScore;
  final String status;

  // explicabilidade
  final List<String> reasons;

  BoletoValidationResponseModel({
    required this.code,
    required this.originalCode,
    required this.boletoType,
    required this.isReal,
    required this.amount,
    required this.amountFormatted,
    required this.dueDate,
    required this.dueDateFormatted,
    required this.isExpired,
    required this.daysOverdue,
    required this.daysUntilDue,
    required this.riskScore,
    required this.status,
    required this.reasons,
  });

  factory BoletoValidationResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return BoletoValidationResponseModel(
      code: json['code'] as String,

      originalCode: json['original_code'] as String,

      boletoType: json['boleto_type'] as String,

      isReal: json['is_real'] as bool,

      amount: double.parse(json['amount'].toString()),

      amountFormatted: json['amount_formatted'] as String,

      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'])
          : null,

      dueDateFormatted:
          json['due_date_formatted'] as String,

      isExpired: json['is_expired'] as bool,

      daysOverdue: json['days_overdue'] as int,

      daysUntilDue: json['days_until_due'] as int?,

      riskScore: json['risk_score'] as int,

      status: (json['status'] as String)
        .trim()
        .toLowerCase(),

      reasons: List<String>.from(
        json['reasons'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'original_code': originalCode,
      'boleto_type': boletoType,
      'is_real': isReal,
      'amount': amount,
      'amount_formatted': amountFormatted,
      'due_date': dueDate?.toIso8601String(),
      'due_date_formatted': dueDateFormatted,
      'is_expired': isExpired,
      'days_overdue': daysOverdue,
      'days_until_due': daysUntilDue,
      'risk_score': riskScore,
      'status': status,
      'reasons': reasons,
    };
  }
}

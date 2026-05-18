class BoletoAnalysisEntity {
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

  const BoletoAnalysisEntity({
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

  bool get isValid => status == 'valid';

  bool get isSuspicious => status == 'suspicious';

  bool get isFraudSuspect =>
      status == 'fraud_suspect';
}

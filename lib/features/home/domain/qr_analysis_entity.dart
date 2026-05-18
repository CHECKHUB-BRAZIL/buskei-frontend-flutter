class QRAnalysisEntity {
  final String rawValue;

  final bool isSafe;

  final int riskScore;

  final List<String> reasons;

  const QRAnalysisEntity({
    required this.rawValue,
    required this.isSafe,
    required this.riskScore,
    required this.reasons,
  });

  bool get hasRisk => riskScore > 0;
}

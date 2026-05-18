class LinkAnalysisEntity {
  final String url;

  final String risk;
  final int riskScore;

  final List<String> reasons;
  final List<String> positives;

  const LinkAnalysisEntity({
    required this.url,
    required this.risk,
    required this.riskScore,
    required this.reasons,
    required this.positives,
  });

  bool get isSafe => risk == 'LOW';

  bool get isMediumRisk => risk == 'MEDIUM';

  bool get isHighRisk => risk == 'HIGH';
}

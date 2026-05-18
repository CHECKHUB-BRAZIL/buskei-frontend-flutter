class AnalyzeLinkResponseModel {
  final String url;
  final String risk;
  final int riskScore;
  final List<String> reasons;
  final List<String> positives;

  AnalyzeLinkResponseModel({
    required this.url,
    required this.risk,
    required this.riskScore,
    required this.reasons,
    required this.positives,
  });

  factory AnalyzeLinkResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AnalyzeLinkResponseModel(
      url: json['url'] as String,

      risk: json['risk'] as String,

      riskScore: json['risk_score'] as int,

      reasons: List<String>.from(
        json['reasons'] ?? [],
      ),

      positives: List<String>.from(
        json['positives'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'risk': risk,
      'risk_score': riskScore,
      'reasons': reasons,
      'positives': positives,
    };
  }
}

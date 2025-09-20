// lib/models/recommendation_model.dart

class HousingRecommendation {
  final String housingType; // 주거 형태 (예: 아파트, 오피스텔)
  final String location; // 지역
  final int deposit; // 보증금 (만원)
  final int rent; // 월세 (만원)
  final String reason; // 추천 사유
  final double matchScore; // 적합도 점수

  HousingRecommendation({
    required this.housingType,
    required this.location,
    required this.deposit,
    required this.rent,
    required this.reason,
    required this.matchScore,
  });
}
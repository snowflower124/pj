// lib/models/ai_diagnosis_model.dart

class AiDiagnosisRequest {
  final int incomeQuintile;
  final int currentIncome;
  final int familyMembers;
  final int childrenCount;
  final bool isMarried;
  final int age;
  final int availableBudget;
  final String location;

  AiDiagnosisRequest({
    required this.incomeQuintile,
    required this.currentIncome,
    required this.familyMembers,
    required this.childrenCount,
    required this.isMarried,
    required this.age,
    required this.availableBudget,
    required this.location,
  });

  // Dart 객체를 JSON(Map)으로 변환
  Map<String, dynamic> toJson() => {
    'incomeQuintile': incomeQuintile,
    'currentIncome': currentIncome,
    'familyMembers': familyMembers,
    'childrenCount': childrenCount,
    'isMarried': isMarried,
    'age': age,
    'availableBudget': availableBudget,
    'location': location,
  };
}

class AiDiagnosisResponse {
  final int recommendedRent;
  final int recommendedJeonse;
  final String recommendedHousingType;

  AiDiagnosisResponse({
    required this.recommendedRent,
    required this.recommendedJeonse,
    required this.recommendedHousingType,
  });

  // JSON(Map)을 Dart 객체로 변환
  factory AiDiagnosisResponse.fromJson(Map<String, dynamic> json) {
    return AiDiagnosisResponse(
      recommendedRent: json['recommendedRent'],
      recommendedJeonse: json['recommendedJeonse'],
      recommendedHousingType: json['recommendedHousingType'],
    );
  }
}
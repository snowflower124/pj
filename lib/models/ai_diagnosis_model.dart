// lib/models/ai_diagnosis_model.dart

// AI 진단 요청 시 보내는 데이터 모델 (확장됨)
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
}

// AI 진단 후 받는 데이터 모델 (기존과 동일)
class AiDiagnosisResponse {
  final int recommendedRent;
  final int recommendedJeonse;
  final String recommendedHousingType;

  AiDiagnosisResponse({
    required this.recommendedRent,
    required this.recommendedJeonse,
    required this.recommendedHousingType,
  });
}
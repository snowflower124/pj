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

  // 👇 오류 해결을 위해 이 함수를 추가하세요.
  Map<String, dynamic> toMap() {
    return {
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
}
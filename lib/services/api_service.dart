import 'dart:io'; //
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';

class ApiService {
  static const String _baseUrl = "http://10.0.2.2:8080/api/v1";

  Future<AiDiagnosisResponse> getAiDiagnosis(AiDiagnosisRequest request) async {
    print("AI 진단 로직 시작: ${request.toMap()}");

    await Future.delayed(const Duration(seconds: 2));

    int recommendedRent;
    int baseRent = (request.currentIncome * 0.25).toInt();
    if (baseRent < 50) {
      recommendedRent = 50;
    } else if (baseRent > 250) {
      recommendedRent = 250;
    } else {
      recommendedRent = baseRent;
    }
    if (request.availableBudget > 30000) {
      recommendedRent += 20;
    }

    int recommendedJeonse = (request.availableBudget * 0.9).toInt();

    List<String> housingTypes = [];
    if (request.familyMembers > 2 || request.childrenCount > 0) {
      housingTypes.add("아파트");
      housingTypes.add("다세대주택");
    } else if (request.familyMembers > 1) {
      housingTypes.add("오피스텔");
      housingTypes.add("다세대주택");
    } else {
      housingTypes.add("원룸");
      housingTypes.add("오피스텔");
    }

    print("AI 진단 결과: 월세 $recommendedRent, 전세 $recommendedJeonse, 형태 ${housingTypes.join(',')}");

    return AiDiagnosisResponse(
      recommendedRent: recommendedRent,
      recommendedJeonse: recommendedJeonse,
      recommendedHousingType: housingTypes.join(','),
    );
  }

  Future<List<HousingListing>> getFilteredListings(Map<String, Set<String>>? filters) async {
    return [];
  }

  Future<List<HousingListing>> getRecommendedListings(AiDiagnosisResponse criteria) async {
    return [];
  }

  // 👇 'File' 클래스를 사용하기 위해 'dart:io'가 올바르게 import 되어야 합니다.
  Future<String> analyzeContractFile(File file) async {
    await Future.delayed(const Duration(seconds: 3));
    return "계약서 분석 결과:\n- 제5조 원상복구 의무 조항에 분쟁 소지가 있습니다.";
  }
}
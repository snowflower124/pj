import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';

class ApiService {
  static const String _baseUrl = "http://10.0.2.2:8080/api/v1";

  // 1. 수동 필터링 API 호출 (지도 검색용)
  Future<List<HousingListing>> getFilteredListings(Map<String, Set<String>>? filters) async {
    final queryParameters = <String, String>{};
    if (filters != null) {
      filters.forEach((key, value) {
        if (value.isNotEmpty) {
          queryParameters[key] = value.join(',');
        }
      });
    }

    final uri = Uri.parse("$_baseUrl/listings").replace(queryParameters: queryParameters);
    print('Request URL (Manual Filter): $uri');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return responseBody.map((json) => HousingListing.fromJson(json)).toList();
      } else {
        throw Exception('매물 목록을 가져오는데 실패했습니다.');
      }
    } catch (e) {
      throw Exception('서버에 연결할 수 없습니다.');
    }
  }

  // 2. AI 추천 API 호출
  Future<List<HousingListing>> getRecommendedListings(AiDiagnosisResponse criteria) async {
    final queryParameters = {
      'availableBudget': criteria.recommendedJeonse.toString(),
      'age': '30', // 예시: 나이는 임시로 고정
    };

    final uri = Uri.parse("$_baseUrl/listings/recommended").replace(queryParameters: queryParameters);
    print('Request URL (AI Recommend): $uri');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return responseBody.map((json) => HousingListing.fromJson(json)).toList();
      } else {
        throw Exception('추천 매물 목록을 가져오는데 실패했습니다.');
      }
    } catch (e) {
      throw Exception('서버에 연결할 수 없습니다.');
    }
  }

  // 3. AI 진단 요청 (가상 데이터 반환)
  Future<AiDiagnosisResponse> getAiDiagnosis(AiDiagnosisRequest request) async {
    print("AI 진단 요청 데이터: ${request.location}, 예산: ${request.availableBudget}만원");

    await Future.delayed(const Duration(seconds: 2));
    return AiDiagnosisResponse(
      recommendedRent: 75,
      recommendedJeonse: 20000,
      recommendedHousingType: '오피스텔,다세대주택',
    );
  }

  // 4. 계약서 파일 분석 (가상 데이터 반환)
  Future<String> analyzeContractFile(File file) async {
    await Future.delayed(const Duration(seconds: 3));
    return "계약서 분석 결과:\n- 제5조 원상복구 의무 조항에 분쟁 소지가 있습니다.";
  }
}
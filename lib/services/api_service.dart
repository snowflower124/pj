import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';

class ApiService {
  static const String _baseUrl = "http://10.0.2.2:8080/api/v1";

  // AI 진단 요청
  Future<AiDiagnosisResponse> getAiDiagnosis(AiDiagnosisRequest request) async {
    print("전송된 데이터: ${request.location}, 예산: ${request.availableBudget}만원");

    await Future.delayed(const Duration(seconds: 2));
    return AiDiagnosisResponse(
      recommendedRent: 75,
      recommendedJeonse: 15000,
      recommendedHousingType: '오피스텔, 다세대주택',
    );
  }

  // 매물 목록 요청
  Future<List<HousingListing>> getFilteredListings(AiDiagnosisResponse criteria) async {
    final url = Uri.parse("$_baseUrl/listings");
    try {
      final response = await http.get(url);
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

  // 계약서 파일 분석 요청
  Future<String> analyzeContractFile(File file) async {
    await Future.delayed(const Duration(seconds: 3));
    return "계약서 분석 결과:\n- 제5조 원상복구 의무 조항에 분쟁 소지가 있습니다.";
  }
}
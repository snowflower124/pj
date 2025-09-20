import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';

class ApiService {
  // 안드로이드 에뮬레이터에서 PC의 localhost 서버에 접속하기 위한 주소
  static const String _baseUrl = "http://10.0.2.2:8080/api/v1";

  // AI 진단 기능 (예시)
  Future<AiDiagnosisResponse> getAiDiagnosis(AiDiagnosisRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    return AiDiagnosisResponse(
      recommendedRent: 75,
      recommendedJeonse: 15000,
      recommendedHousingType: '오피스텔, 다세대주택',
    );
  }

  // 매물 목록을 가져오는 함수
  Future<List<HousingListing>> getFilteredListings(AiDiagnosisResponse criteria) async {
    final url = Uri.parse("$_baseUrl/listings");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return responseBody.map((json) => HousingListing.fromJson(json)).toList();
      } else {
        throw Exception('매물 목록을 가져오는데 실패했습니다. (상태 코드: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('서버에 연결할 수 없습니다. 네트워크 상태를 확인해주세요.');
    }
  }
}
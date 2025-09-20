// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http; // <<<--- ':' 오타를 수정했습니다.
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';

class ApiService {
  // TODO: 실제 백엔드 서버 주소로 변경하세요.
  static const String _baseUrl = "https://your-backend-server.com/api/v1";

  Future<AiDiagnosisResponse> getAiDiagnosis(AiDiagnosisRequest request) async {
    // AI 진단 요청 시뮬레이션
    await Future.delayed(const Duration(seconds: 2));
    return AiDiagnosisResponse(
      recommendedRent: 75,
      recommendedJeonse: 15000,
      recommendedHousingType: '오피스텔, 다세대주택',
    );
  }

  Future<List<HousingListing>> getFilteredListings(AiDiagnosisResponse criteria) async {
    // API 요청 URL에 쿼리 파라미터 추가 (예: /listings?rent=75&type=오피스텔)
    // final url = Uri.parse("$_baseUrl/listings?rent=${criteria.recommendedRent}&type=${criteria.recommendedHousingType}"); // 실제 연동 시 url 변수 사용

    // --- 실제 백엔드 연동 시 아래 코드를 사용 ---
    /*
    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return responseBody.map((json) => HousingListing.fromJson(json)).toList();
      } else {
        throw Exception('추천 매물 목록을 가져오는데 실패했습니다.');
      }
    } catch (e) {
      throw Exception('네트워크 연결에 실패했습니다.');
    }
    */

    // --- 시뮬레이션을 위한 가상 코드 ---
    await Future.delayed(const Duration(seconds: 2));
    return [
      HousingListing(id: '1', housingType: '오피스텔', location: '서울시 관악구 신림동', deposit: 1000, rent: criteria.recommendedRent, description: '신축, 역세권 5분 거리'),
      HousingListing(id: '2', housingType: '다세대주택', location: '서울시 동작구 상도동', deposit: 2000, rent: criteria.recommendedRent - 5, description: '조용한 주택가, 리모델링 완료'),
      HousingListing(id: '4', housingType: '원룸', location: '서울시 관악구 봉천동', deposit: 500, rent: criteria.recommendedRent + 5, description: '대학가 인접, 풀옵션'),
    ];
  }
}
// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';

class ApiService {
  static const String _baseUrl = "https://your-backend-server.com/api/v1";

  Future<AiDiagnosisResponse> getAiDiagnosis(AiDiagnosisRequest request) async {
    await Future.delayed(const Duration(seconds: 2));
    return AiDiagnosisResponse(
      recommendedRent: 75,
      recommendedJeonse: 15000,
      recommendedHousingType: '오피스텔, 다세대주택',
    );
  }

  Future<List<HousingListing>> getFilteredListings(AiDiagnosisResponse criteria) async {
    final url = Uri.parse("$_baseUrl/listings?rent=${criteria.recommendedRent}&type=${criteria.recommendedHousingType}");

    // --- 실제 연동 시 주석 해제 ---
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

    // --- 시뮬레이션 코드 ---
    await Future.delayed(const Duration(seconds: 2));
    return [
      // --- 👇 누락되었던 lat, lng 값을 추가했습니다 ---
      HousingListing(id: '1', housingType: '오피스텔', location: '서울시 관악구 신림동', deposit: 1000, rent: criteria.recommendedRent, description: '신축, 역세권 5분 거리', lat: 37.4849, lng: 126.9295),
      HousingListing(id: '2', housingType: '다세대주택', location: '서울시 동작구 상도동', deposit: 2000, rent: criteria.recommendedRent - 5, description: '조용한 주택가, 리모델링 완료', lat: 37.5000, lng: 126.9420),
      HousingListing(id: '4', housingType: '원룸', location: '서울시 관악구 봉천동', deposit: 500, rent: criteria.recommendedRent + 5, description: '대학가 인접, 풀옵션', lat: 37.4781, lng: 126.9515),
    ];
  }
}
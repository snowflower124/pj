// lib/services/api_service.dart

import 'dart:convert';
// import 'package:http/http.dart' as http;
import 'package:zari/models/ai_diagnosis_model.dart';

class ApiService {
  // TODO: 실제 백엔드 서버 주소로 변경하세요.
  static const String _baseUrl = "https://your-backend-server.com/api/v1";

  Future<AiDiagnosisResponse> getAiDiagnosis(AiDiagnosisRequest request) async {
    // final url = Uri.parse("$_baseUrl/diagnosis");

    // --- 실제 백엔드 연동 시 아래 코드를 사용 ---
    /*
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        return AiDiagnosisResponse.fromJson(responseBody);
      } else {
        throw Exception('AI 진단 결과를 가져오는데 실패했습니다. (서버 에러)');
      }
    } catch (e) {
      throw Exception('네트워크 연결에 실패했습니다. 인터넷 상태를 확인해주세요.');
    }
    */

    // --- 시뮬레이션을 위한 가상 코드 ---
    await Future.delayed(const Duration(seconds: 2));
    print("Request Body: ${jsonEncode(request.toJson())}");
    
    // '실패' 응답 부분의 주석을 해제하여 에러를 발생시킵니다.
    throw Exception('시뮬레이션 에러 발생');
  }
}
package com.example.zari.controller;

import com.example.zari.dto.HousingListingDto;
import org.springframework.web.bind.annotation.*; // @PostMapping, @RequestParam 추가를 위해 * 로 변경
import org.springframework.web.multipart.MultipartFile; // 파일 업로드를 위해 추가

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map; // Map 사용을 위해 추가

@RestController
@RequestMapping("/api/v1")
public class ListingController {

    @GetMapping("/listings")
    public List<HousingListingDto> getListings() {
        return Arrays.asList(
                new HousingListingDto("1", "오피스텔", "서울시 관악구 신림동", 1000, 70, "신축, 역세권 5분 거리", 37.4849, 126.9295),
                new HousingListingDto("2", "다세대주택", "서울시 동작구 상도동", 2000, 55, "조용한 주택가, 리모델링 완료", 37.5000, 126.9420),
                new HousingListingDto("3", "아파트", "서울시 구로구 구로동", 5000, 90, "대단지, 편의시설 인접", 37.4954, 126.8872)
        );
    }

    // AI 계약서 이미지 분석을 위한 새로운 API 엔드포인트
    @PostMapping("/analyze-contract") // POST 요청을 http://localhost:8080/api/v1/analyze-contract 로 받음
    public Map<String, String> analyzeContract(@RequestParam("image") MultipartFile image) {
        if (image.isEmpty()) {
            // 파일이 비어있는 경우 처리
            return Map.of("analysisResult", "업로드된 파일이 없습니다.");
        }

        try {
            // 여기에서 실제 AI 분석 로직을 구현합니다.
            // 예시: 이미지 데이터를 읽어 어떤 AI 모델로 전송, 결과 수신
            String fileName = image.getOriginalFilename();
            long fileSize = image.getSize();
            String contentType = image.getContentType();

            // TODO: 실제 AI 모델 연동 (TensorFlow, PyTorch 등) 또는 외부 AI 서비스 API 호출
            // 현재는 가상의 분석 결과를 반환합니다.
            String mockAnalysis = "계약서 분석 결과: \n\n" +
                    "계약자 정보: 김민수(임대인), 박지영(임차인)\n" +
                    "주소: 서울시 강남구 테헤란로 123\n" +
                    "보증금: 1억원, 월세: 100만원\n" +
                    "계약 기간: 2024년 5월 1일 ~ 2026년 4월 30일 (2년)\n\n" +
                    "부당 조항 여부: \n" +
                    "- 제5조 (원상복구 의무): 임차인의 통상적인 마모에 대한 원상복구 의무가 과도하게 명시되어 있습니다. 이 조항은 분쟁의 소지가 있습니다.\n" +
                    "- 제7조 (중도 해지): 임차인이 중도 해지 시 과도한 위약금(잔여 기간 월세 전부)을 지불해야 합니다. 이는 불공정 조항일 수 있습니다.\n" +
                    "- 특약사항 3항: 반려동물 사육 금지 조항이 명확하지 않아 해석의 여지가 있습니다.\n\n" +
                    "종합 의견: 일부 조항에 대한 법률 검토가 필요합니다. 특히 원상복구 및 중도 해지 조항에 대해 변호사 상담을 권유합니다.";

            return Map.of("analysisResult", mockAnalysis);

        } catch (Exception e) {
            e.printStackTrace();
            return Map.of("analysisResult", "계약서 분석 중 오류가 발생했습니다: " + e.getMessage());
        }
    }
}
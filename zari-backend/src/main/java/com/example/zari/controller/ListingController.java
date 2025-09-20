package com.example.zari.controller;

import com.example.zari.dto.HousingListingDto;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1")
public class ListingController {

    // 전체 매물 데이터 (DB 역할)
    private final List<HousingListingDto> allListings = Arrays.asList(
            new HousingListingDto("1", "오피스텔", "월세", "서울시 관악구 신림동", 1000, 70, "신축, 역세권 5분 거리", 37.4849, 126.9295),
            new HousingListingDto("2", "다세대주택", "전세", "서울시 동작구 상도동", 20000, 0, "조용한 주택가", 37.5000, 126.9420),
            new HousingListingDto("3", "아파트", "매매", "서울시 구로구 구로동", 50000, 0, "대단지", 37.4954, 126.8872),
            new HousingListingDto("4", "원룸", "월세", "서울시 관악구 봉천동", 500, 45, "대학가 인접", 37.4781, 126.9515),
            new HousingListingDto("5", "아파트", "월세", "서울시 강남구 역삼동", 5000, 200, "고급 아파트", 37.5006, 127.0364)
    );

    // 1. 수동 필터링 매물 검색 API
    @GetMapping("/listings")
    public List<HousingListingDto> getListings(
            @RequestParam(required = false) List<String> transactionTypes,
            @RequestParam(required = false) List<String> housingTypes) {

        System.out.println("[Manual Filter] Received transactionTypes: " + transactionTypes);
        System.out.println("[Manual Filter] Received housingTypes: " + housingTypes);

        return allListings.stream()
                .filter(listing -> (transactionTypes == null || transactionTypes.isEmpty()) || transactionTypes.contains(listing.getTransactionType()))
                .filter(listing -> (housingTypes == null || housingTypes.isEmpty()) || housingTypes.contains(listing.getHousingType()))
                .collect(Collectors.toList());
    }

    // 2. AI 추천 매물 검색 API
    @GetMapping("/listings/recommended")
    public List<HousingListingDto> getRecommendedListings(@RequestParam int availableBudget, @RequestParam int age) {
        System.out.println("[AI Recommend] Received availableBudget: " + availableBudget + ", age: " + age);

        // 예산과 나이에 맞는 매물을 필터링하는 간단한 로직 (예시)
        return allListings.stream()
                .filter(listing -> listing.getDeposit() <= availableBudget)
                .limit(2) // 상위 2개만 추천
                .collect(Collectors.toList());
    }
}
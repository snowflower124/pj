package com.example.zari.controller;

import com.example.zari.dto.HousingListingDto;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/api/v1")
public class ListingController {

    @GetMapping("/listings")
    public List<HousingListingDto> getListings() {
        // 실제로는 DB에서 데이터를 조회해야 합니다.
        return Arrays.asList(
                new HousingListingDto("1", "오피스텔", "서울시 관악구 신림동", 1000, 70, "신축, 역세권 5분 거리", 37.4849, 126.9295),
                new HousingListingDto("2", "다세대주택", "서울시 동작구 상도동", 2000, 55, "조용한 주택가, 리모델링 완료", 37.5000, 126.9420),
                new HousingListingDto("3", "아파트", "서울시 구로구 구로동", 5000, 90, "대단지, 편의시설 인접", 37.4954, 126.8872)
        );
    }
}
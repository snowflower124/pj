package com.example.zari.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public class HousingListingDto {
    private String id;
    private String housingType;
    private String transactionType; // 필터링을 위해 추가
    private String location;
    private int deposit;
    private int rent;
    private String description;
    private double lat;
    private double lng;
}
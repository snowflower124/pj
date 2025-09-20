// lib/data/mock_listings.dart
import 'package:zari/models/listing_model.dart';

final List<HousingListing> allListings = [
  HousingListing(id: '1', housingType: '오피스텔', location: '서울시 관악구 신림동', deposit: 1000, rent: 70, description: '신축, 역세권 5분 거리', lat: 37.4849, lng: 126.9295),
  HousingListing(id: '2', housingType: '다세대주택', location: '서울시 동작구 상도동', deposit: 2000, rent: 55, description: '조용한 주택가, 리모델링 완료', lat: 37.5000, lng: 126.9420),
  HousingListing(id: '3', housingType: '아파트', location: '서울시 구로구 구로동', deposit: 5000, rent: 90, description: '대단지, 편의시설 인접', lat: 37.4954, lng: 126.8872),
  HousingListing(id: '4', housingType: '원룸', location: '서울시 관악구 봉천동', deposit: 500, rent: 45, description: '대학가 인접, 풀옵션', lat: 37.4781, lng: 126.9515),
  HousingListing(id: '5', housingType: '오피스텔', location: '서울시 강남구 역삼동', deposit: 2000, rent: 120, description: '업무지구 중심, 보안 철저', lat: 37.5006, lng: 127.0364),
];
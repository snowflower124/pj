// lib/models/listing_model.dart

class HousingListing {
  final String id;
  final String housingType;
  final String location;
  final int deposit;
  final int rent;
  final String description;
  final double lat; // 위도 추가
  final double lng; // 경도 추가

  HousingListing({
    required this.id,
    required this.housingType,
    required this.location,
    required this.deposit,
    required this.rent,
    required this.description,
    required this.lat,
    required this.lng,
  });

  factory HousingListing.fromJson(Map<String, dynamic> json) {
    return HousingListing(
      id: json['id'] ?? '',
      housingType: json['housingType'] ?? '정보 없음',
      location: json['location'] ?? '정보 없음',
      deposit: json['deposit'] ?? 0,
      rent: json['rent'] ?? 0,
      description: json['description'] ?? '설명 없음',
      lat: json['lat'] ?? 37.5665, // 기본값: 서울 시청
      lng: json['lng'] ?? 126.9780,
    );
  }
}
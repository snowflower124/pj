// lib/models/listing_model.dart

class HousingListing {
  final String id;
  final String housingType;
  final String location;
  final int deposit;
  final int rent;
  final String description;

  HousingListing({
    required this.id,
    required this.housingType,
    required this.location,
    required this.deposit,
    required this.rent,
    required this.description,
  });

  // 서버에서 받은 JSON 데이터를 HousingListing 객체로 변환하는 로직
  factory HousingListing.fromJson(Map<String, dynamic> json) {
    return HousingListing(
      id: json['id'] ?? '',
      housingType: json['housingType'] ?? '정보 없음',
      location: json['location'] ?? '정보 없음',
      deposit: json['deposit'] ?? 0,
      rent: json['rent'] ?? 0,
      description: json['description'] ?? '설명 없음',
    );
  }
}
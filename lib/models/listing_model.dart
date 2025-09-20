class HousingListing {
  final String id;
  final String housingType;
  final String transactionType; // 👈 이 줄을 추가하세요.
  final String location;
  final int deposit;
  final int rent;
  final String description;
  final double lat;
  final double lng;

  HousingListing({
    required this.id,
    required this.housingType,
    required this.transactionType, // 👈 생성자에도 추가
    required this.location,
    required this.deposit,
    required this.rent,
    required this.description,
    required this.lat,
    required this.lng,
  });

  // JSON 데이터를 Dart 객체로 변환하는 부분
  factory HousingListing.fromJson(Map<String, dynamic> json) {
    return HousingListing(
      id: json['id'] ?? '',
      housingType: json['housingType'] ?? '정보 없음',
      transactionType: json['transactionType'] ?? '정보 없음', // 👈 JSON 파싱 로직 추가
      location: json['location'] ?? '정보 없음',
      deposit: json['deposit'] ?? 0,
      rent: json['rent'] ?? 0,
      description: json['description'] ?? '설명 없음',
      lat: (json['lat'] ?? 0.0).toDouble(),
      lng: (json['lng'] ?? 0.0).toDouble(),
    );
  }
}
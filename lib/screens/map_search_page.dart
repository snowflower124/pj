import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:zari/models/listing_model.dart';
import 'package:zari/screens/filter_screen.dart';
import 'package:zari/services/api_service.dart';

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fetchListings(null); // 처음에는 필터 없이 전체 목록을 불러옵니다.
  }

  // 수동 필터 값으로 서버에서 매물 목록을 가져오는 함수
  Future<void> _fetchListings(Map<String, Set<String>>? filters) async {
    try {
      final listings = await _apiService.getFilteredListings(filters);
      final newMarkers = listings.map((listing) => Marker(
        markerId: listing.id,
        latLng: LatLng(listing.lat, listing.lng),
        infoWindowContent: '<div style="padding:10px;">${listing.housingType}<br>${listing.transactionType}</div>',
      )).toSet();

      setState(() {
        markers = newMarkers;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('매물 정보를 불러오는데 실패했습니다: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('지도에서 매물 찾기'),
      ),
      body: Stack(
        children: [
          KakaoMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            markers: markers.toList(),
            center: LatLng(37.4980, 126.9295),
          ),
          _buildBottomSearchBar(),
        ],
      ),
    );
  }

  Widget _buildBottomSearchBar() {
    return Positioned(
      bottom: 20,
      left: 16,
      right: 16,
      child: GestureDetector(
        onTap: () async {
          // 필터 화면을 띄우고, 결과(filterData)를 기다립니다.
          final filterData = await showModalBottomSheet<Map<String, Set<String>>>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const FilterScreen(),
          );

          // 필터 데이터가 반환되었으면 (null이 아니면) API를 다시 호출합니다.
          if (filterData != null) {
            _fetchListings(filterData);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Text("위치, 거래 유형, 매물 종류 등 필터", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
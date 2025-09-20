import 'package:flutter/material.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:zari/data/mock_listings.dart';
import 'package:zari/screens/filter_screen.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  late KakaoMapController mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    markers = allListings
        .map((listing) => Marker(
      markerId: listing.id,
      latLng: LatLng(listing.lat, listing.lng),
    ))
        .toSet();
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
              setState(() {});
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
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const FilterScreen(),
          );
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
          // --- 👇 누락되었던 child와 그 내용(Row)을 추가했습니다 ---
          child: Row(
            children: const [
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
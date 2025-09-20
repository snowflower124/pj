// lib/screens/listings_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:zari/data/mock_listings.dart';
import 'package:zari/screens/filter_screen.dart';

class ListingsPage extends StatefulWidget {
  const ListingsPage({super.key});

  @override
  State<ListingsPage> createState() => _ListingsPageState();
}

class _ListingsPageState extends State<ListingsPage> {
  final Completer<NaverMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('지도에서 매물 찾기'),
      ),
      body: Stack(
        children: [
          NaverMap(
            options: const NaverMapViewOptions(
              initialCameraPosition: NCameraPosition(
                target: NLatLng(37.4980, 126.9295),
                zoom: 14,
              ),
            ),
            onMapReady: (controller) async {
              _mapController.complete(controller);

              final markers = allListings.map((listing) {
                final marker = NMarker(
                  id: listing.id,
                  position: NLatLng(listing.lat, listing.lng),
                );

                marker.setOnTapListener((_) async {
                  final mapController = await _mapController.future;
                  final currentZoom = (await mapController.getCameraPosition()).zoom;

                  final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
                    target: marker.position,
                    zoom: currentZoom < 15 ? 15 : currentZoom + 1,
                  );

                  // --- 💡 최종 수정: v1.4.1에서는 animateCamera 대신 updateCamera를 사용합니다. (애니메이션 없음) ---
                  mapController.updateCamera(cameraUpdate);
                });
                return marker;
              }).toList();

              controller.addOverlayAll(Set.from(markers));
            },
          ),
          _buildBottomSearchBar(),
        ],
      ),
    );
  }

  Widget _buildBottomSearchBar() {
    // 이 부분은 수정할 필요 없습니다.
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
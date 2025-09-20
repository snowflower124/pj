import 'package:flutter/material.dart';

class ListingsPage extends StatelessWidget {
  const ListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: false, title: const Text('내 주변 매물')),
      body: Container(
        height: double.infinity,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            const Center(child: Text("지도 영역", style: TextStyle(color: Colors.grey, fontSize: 20))),
            _buildListingPin(top: 50, left: 60),
            _buildListingPin(top: 120, left: 200),
            _buildListingPin(bottom: 80, right: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildListingPin({double? top, double? bottom, double? left, double? right}) {
    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]),
        child: const Text("500/55", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
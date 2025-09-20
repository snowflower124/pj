// lib/screens/filtered_results_page.dart

import 'package:flutter/material.dart';
import 'package:zari/models/ai_diagnosis_model.dart';
import 'package:zari/models/listing_model.dart';
import 'package:zari/services/api_service.dart';

class FilteredResultsPage extends StatefulWidget {
  // 필터링 '조건'이 되는 AI 진단 결과를 전달받음
  final AiDiagnosisResponse criteria;
  const FilteredResultsPage({super.key, required this.criteria});

  @override
  State<FilteredResultsPage> createState() => _FilteredResultsPageState();
}

class _FilteredResultsPageState extends State<FilteredResultsPage> {
  late Future<List<HousingListing>> _listingsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // 페이지가 열릴 때 API를 호출하여 매물 데이터를 가져옴
    _listingsFuture = _apiService.getFilteredListings(widget.criteria);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("AI 맞춤 추천 매물"),
      ),
      body: FutureBuilder<List<HousingListing>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          // 1. 로딩 중일 때
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. 에러가 발생했을 때
          if (snapshot.hasError) {
            return Center(child: Text("오류가 발생했습니다: ${snapshot.error}"));
          }
          // 3. 데이터가 없거나 비어있을 때
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("조건에 맞는 매물이 없습니다."));
          }

          // 4. 성공적으로 데이터를 받았을 때
          final listings = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: listings.length,
            itemBuilder: (context, index) {
              return _buildListingCard(context, listings[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildListingCard(BuildContext context, HousingListing item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.housingType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
            const SizedBox(height: 8),
            Text(item.location, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text("보증금 ${item.deposit}만원 / 월세 ${item.rent}만원", style: const TextStyle(color: Colors.black54)),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.blue, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(item.description, style: const TextStyle(fontStyle: FontStyle.italic))),
              ],
            )
          ],
        ),
      ),
    );
  }
}